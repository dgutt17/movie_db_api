require 'query_methods'
require 'importer_parsing_methods'
require 'labels'

class TitleBasicsImporter
    include ImporterParsingMethods

    attr_accessor :file_path, :count, :headers, :content_hash

    def initialize(content_hash)
        @file_path = ENV['TITLE_BASICS_PATH'] 
        @batch_update_movies = batch_update_movies
        @batch_update_tv_shows = batch_update_tv_shows
        @batch_create_categorized_as_relationships = batch_create_categorized_as_relationships
        @batch_create_released_relationships = batch_create_released_relationships
        @count = 0
        @content_hash = content_hash
        @deletion_count = 0
    end

    def run
        File.open(file_path) do |file|
            title_basics_parser(file)
        end

        import
        puts "How many should be deleted: #{@deletion_count}"
    end

    private

    def title_basics_parser(file)
        file.each_with_index do |row, index|
            if index == 0
                @headers = create_headers(row)
            elsif @count == 50000
                import
            else
                row = parse_row(row)
                next if !content_hash[row[:tconst].to_sym]
                if can_add_data?(row)
                    collect(row)
                else
                    @deletion_count += 1
                    # collect_for_deletion(row)
                end
                @count += 1
            end
        end
    end

    def batch_update_movies
        BatchUpdate::Nodes::Movies.new
    end

    def batch_update_tv_shows
        BatchUpdate::Nodes::TvShows.new
    end

    def batch_create_categorized_as_relationships
        BatchCreate::Relationships::CategorizedAs.new
    end

    def batch_create_released_relationships
        BatchCreate::Relationships::Released.new
    end

    def collect(row)
        @batch_update_movies.collect(row)
        @batch_update_tv_shows.collect(row)
        @batch_create_categorized_as_relationships.collect(row)
        @batch_create_released_relationships.collect(row)
    end

    def collect_for_deletion(row)
        @batch_update_movies.collect_for_deletion(row)
        @batch_update_tv_shows.collect_for_deletion(row)
    end

    def import
        @count = 0
        puts "unwinding.............................................."
        @batch_update_movies.import
        @batch_update_tv_shows.import
        @batch_create_categorized_as_relationships.import
        @batch_create_released_relationships.import
        puts "done..................................................."
    end
end
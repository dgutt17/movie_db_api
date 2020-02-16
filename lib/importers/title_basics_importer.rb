require 'query_methods'
require 'importer_parsing_methods'
require 'labels'

class TitleBasicsImporter
    include ImporterParsingMethods

    attr_accessor :file_path, :count, :headers, :content_hash

    def initialize
        @file_path = ENV['TITLE_BASICS_PATH'] 
        @batch_create_movies = batch_create_movies
        @batch_create_tv_shows = batch_create_tv_shows
        @batch_create_categorized_as_relationships = batch_create_categorized_as_relationships
        @batch_create_relased_relationships = batch_create_relased_relationships
        @count = 0
        @content_hash = {}
    end

    def run
        File.open(file_path) do |file|
            title_basics_parser(file)
        end
        # Importing the remaining movies and relationships.
        import if @movies.length > 0

        @content_hash
    end

    private

    def title_basics_parser(file)
        file.each_with_index do |row, index|
            if index == 0
                @headers = create_headers(row)
            elsif @count == 50000
                import
            elsif can_add_data?(row)
                row = parse_row(row)
                collect(row)
                @count += 1
            end
        end
    end

    def batch_create_movies
        BatchCreate::Nodes::Movies.new
    end

    def batch_create_tv_shows
        BatchCreate::Nodes::TvShows.new
    end

    def batch_create_categorized_as_relationships
        BatchCreate::Relationships::CategorizedAs.new
    end

    def batch_create_released_relationships
        BatchCreate::Relationships::Released.new
    end

    def collect(row)
        @batch_create_movies.collect(row)
        @batch_create_tv_shows.collect(row)
        @batch_create_categorized_as_relationships.collect(row)
        @batch_create_relased_relationships.collect(row)
    end

    def import
        puts "unwinding.............................................."
        @batch_create_movies.import
        @batch_create_tv_shows.import
        @batch_create_categorized_as_relationships.import
        @batch_create_relased_relationships.import
        puts "done..................................................."
    end
end
require 'query_methods'
require 'importer_parsing_methods'
require 'labels'

class TitleBasicsImporter
    include ImporterParsingMethods

    attr_accessor :file_path, :count, :headers, :content_hash, :ratings_hash

    def initialize(ratings_hash)
        @file_path = ENV['TITLE_BASICS_PATH'] 
        @batch_create_movies = batch_create_movies
        @batch_create_tv_shows = batch_create_tv_shows
        @batch_create_categorized_as_relationships = batch_create_categorized_as_relationships
        @batch_create_released_relationships = batch_create_released_relationships
        @batch_create_rated_relationships = batch_create_rated_relationships
        @count = 0
        @content_hash = {}
        @ratings_hash = ratings_hash
    end

    def run
        File.open(file_path) do |file|
            title_basics_parser(file)
        end

        import
        content_hash
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
                if can_add_data?(row)
                    collect(row)
                    @count += 1
                end
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

    def batch_create_rated_relationships
        BatchCreate::Relationships::Rated.new
    end

    def collect(row)
        if ratings_hash[row[:tconst]].present?
            row = row.merge(ratings_hash[row[:tconst]])
            @batch_create_movies.collect(row)
            @batch_create_tv_shows.collect(row)
            @batch_create_categorized_as_relationships.collect(row)
            @batch_create_released_relationships.collect(row)
            @batch_create_rated_relationships.collect(row)
        end
    end

    def import
        @count = 0
        puts "unwinding.............................................."
        movie_cypher_obj = @batch_create_movies.import
        tv_show_cypher_hash = @batch_create_tv_shows.import
        @batch_create_categorized_as_relationships.import
        @batch_create_released_relationships.import
        @batch_create_rated_relationships.import

        add_to_content_hash(movie_cypher_obj, tv_show_cypher_hash)
        puts "done..................................................."
    end

    def add_to_content_hash(movie_cypher_obj, tv_show_cypher_hash)
        parse_cypher_return_node_object(movie_cypher_obj)
        parse_cypher_return_node_object(tv_show_cypher_hash)
    end
end
module ImdbParser
    class Movie
        attr_accessor :release_year, :genres, :node

        def initialize(movie)
            # @imdb_id = movie.first
            # @title = movie[2].gsub(/'/, '|')
            @release_year = movie[5]
            # @run_time = movie[7]
            @genres = movie.last.split(",").map {|genre| genre.gsub(/[^0-9a-z ]/i, '')}
            @node = {imdb_id: movie.first, title: movie[2].gsub(/'/, '|'), runtime: movie[7].to_i}
        end

        def create_genre_relationship
            relationships = []
            @genres.each do |genre|
                relationships << {from: @node[:imdb_id], to: genre}
            end

            return relationships
        end

        def create_year_relationship
            return {from: @node[:imdb_id], to: @release_year.to_i}
        end

        # def str_validate(string)
        #     !string.match(/\A[a-zA-Z0-9]*\z/).nil? || string == "Sci-Fi"
        # end

        # def sanitize_run_time(run_time)
        #     run_time.to_i
        # end

        # def save!
        #     $neo4j_session.query(@query_string)
        # end
    end
end
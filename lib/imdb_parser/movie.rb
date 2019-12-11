module ImdbParser
    class Movie
        attr_accessor :imdb_id, :label, :title, :release_year, :run_time, :genres

        def initialize(movie)
            @imdb_id = movie.first
            @title = movie[2].gsub(/'/, '|')
            @release_year = movie[5]
            @run_time = movie[7]
            @genres = movie.last.split(",").map {|genre| genre.gsub(/[^0-9a-z ]/i, '')}
        end

        def create
            {imdb_id: @imdb_id, title: @title, runtime: @run_time.to_i}
        end

        # def create_genre_relationship
        #     query_str = String.new
        #     @genres.each do |genre|
        #         query_str += "MERGE (:Movie {imdb_id: '#{@imdb_id}'})-[:CATEGORIZED_AS]->(:Genre {name: '#{genre}'})"
        #     end

        #     query_str
        # end

        # def create_year_relationship
        #     "MERGE (:Movie {imdb_id: '#{@imdb_id}'})-[:RELEASE_YEAR]->(m:Year {name: '#{@release_year}'})"
        # end

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
module ImdbParser
    class Movie
        attr_accessor :imdb_id, :label, :title, :release_year, :run_time, :genres

        def initialize(movie)
            @imdb_id = movie.first
            @title = movie[2].gsub(/'/, '|')
            @release_year = movie[5]
            @run_time = movie[7]
            @genres = movie.last.split(",").select {|genre| self.str_validate(genre)}
            @query_string = create_genre + create_movie + create_genre_relationship + create_year_relationship
        end

        def create_genre
            Genre.match_or_create(@genres)
        end

        def create_movie
            "CREATE (n:Movie {imdb_id: '#{@imdb_id}', title: '#{@title}', runtime: '#{@run_time.to_i}'});"
        end

        def create_genre_relationship
            query_str = String.new
            @genres.each do |genre|
                query_str += "MATCH (n:Movie {imdb_id: '#{@imdb_id}'}), (m:Genre {name: '#{genre}'}) CREATE (n)-[:CATEGORIZED_AS]->(m);"
            end

            query_str
        end

        def create_year_relationship
            "MATCH (n:Movie {imdb_id: '#{@imdb_id}'}), (m:Year {name: '#{@release_year}'}) CREATE (n)-[:RELEASE_YEAR]->(m)"
        end

        def str_validate(string)
            !string.match(/\A[a-zA-Z0-9]*\z/).nil? || string == "Sci-Fi"
        end

        def sanitize_run_time(run_time)
            run_time.to_i
        end

        def save!
            $neo4j_session.query(@query_string)
        end
    end
end
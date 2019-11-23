module ImdbParser
    class Movie
        attr_accessor :imdb_id, :label, :title, :release_year, :run_time, :genres

        def initialize(movie)
            @imdb_id = movie.first
            @title = movie[2]
            @release_year = movie[5]
            @run_time = movie[7]
            @genres = movie.last.split(",")
        end

        def create_genre
            Genre.match_or_create(@genres)
        end

        def create_movie
            $neo4j_session.query("CREATE (n:Movie {imdb_id: #{@imdb_id}, title: #{@title}, runtime: #{@runtime})")
        end

        def create_genre_relationship
            
        end

        def create_year_relationship
        end
    end
end
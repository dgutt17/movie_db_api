module ImdbParser
    class Movie
        attr_accessor :imdb_id, :label, :title, :release_year, :run_time, :genres, :session

        def initialize(movie)
            @imdb_id = movie.first
            @title = movie[2]
            @release_year = movie[5]
            @run_time = movie[7]
            @genres = movie.last.split(",")
            @session = Neo4j::Driver.new.session
        end

        def create_genre
            Genre.match_or_create(@genres)
        end

        def create_movie
            @genres.each do |genre|
                @session.query("MERGE (n:Movie {imdb_id: #{@imdb_id}, title: #{@title}, runtime: #{@runtime}) -[]-> (m: Genre {name: #{genre}})")
            end
        end

        def create_movie_genre_relationship
        end

        def create_movie_year_relationship
        end
    end
end
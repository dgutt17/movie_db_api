module ImdbParser
    class Movie
        attr_accessor :imdb_id, :label, :title, :release_year, :run_time, :genres, :session

        def initialize(movie)
            @imdb_id = movie.first
            @title = movie[2]
            @release_year = movie[5]
            @run_time = movie[7]
            @genres = movie.last.split(",")
            @session = NEO4J_DRIVER.session
        end

        def create_genre
            Genre.match_or_create(@genres)
        end

        def create_movie
            @genres.each do |genre|
                @session.query("MATCH (m:Genre {name: #{@genre}}, CREATE (n:Movie {imdb_id: #{@imdb_id}, title: #{@title}, runtime: #{@runtime}) -[r:CATEGORIZED_AS]-> (m)")
                @session.query("MATCH (n:Movie {imdb_id: #{@imdb_id}}) (m:Year {value: #{release_year}}), CREATE (n)-[:RELEASED_IN]->(m)")
            end
        end

        def create_movie_genre_relationship
        end

        def create_movie_year_relationship
        end
    end
end
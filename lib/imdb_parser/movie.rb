module ImdbParser
    class Movie
        attr_accessor :imdb_id, :label, :title, :release_year, :run_time, :genres

        def initialize(movie)
            @imdb_id = movie.first
            @label = 'movie'
            @title = movie[2]
            @release_year = movie[5]
            @run_time = movie[7]
            @genres = movie.last
        end

        
    end
end
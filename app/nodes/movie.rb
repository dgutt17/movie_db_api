class Movie < Node
    attr_accessor :node

    def initialize(movie)
        @node = {imdb_id: movie.first, title: parse_title(movie), runtime: parse_runtime(movie)}
    end

    private

    def parse_title(movie)
        movie[2].gsub(/'/, '|')
    end

    def parse_runtime(movie)
        movie[7].to_i
    end
end
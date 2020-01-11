class Movie < Node
    attr_accessor :node, :movie

    def initialize(movie)
        @movie = movie
        @node = {imdb_id: movie[:tconst], title: parse_title, runtime: parse_runtime}
    end

    private

    def parse_title
        movie[:primaryTitle].gsub(/'/, '|')
    end

    def parse_runtime
        movie[:runtimeMinutes].to_i
    end
end
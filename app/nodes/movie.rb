class Movie < Node
    attr_reader :movie

    def initialize(movie)
        @movie = movie
    end

    def node
        @node ||= {
            id: movie[:tconst],
            properties: {
                title: parse_title, 
                runtime: parse_runtime
            }
        }
    end

    private

    def parse_title
        movie[:primaryTitle].gsub(/'/, '|')
    end

    def parse_runtime
        movie[:runtimeMinutes].to_i
    end
end
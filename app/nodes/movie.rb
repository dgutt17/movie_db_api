class Movie < Node
    attr_reader :movie

    def initialize(movie)
        @movie = movie
    end

    def node
        @node ||= {
            id: movie[:tconst],
            properties: {
                imdb_id: movie[:tconst],
                title: parse_title, 
                imdb_rating: movie[:averageRating].to_f,
                number_of_votes: movie[:numVotes].split("\n").first.to_i,
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
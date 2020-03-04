class Movie < Node
    attr_accessor :node, :movie

    def self.find(imdb_id)
        
    end

    def initialize(movie)
        @movie = movie
        @node = {
            id: movie[:tconst],
            properties: {
                imdb_id: movie[:tconst], 
                title: parse_title, 
                runtime: parse_runtime,
                imdb_score: parse_score,
                num_of_votes: parse_votes
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

    def parse_score
        movie[:averageRating].to_f
    end

    def parse_votes
        movie[:numVotes].to_i
    end
end
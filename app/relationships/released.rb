class Released < Relationship
    attr_accessor :node

    def initialize(movie)
        imdb_id = movie[:tconst]
        release_year = movie[:startYear].to_i

        @node = {from: imdb_id, to: release_year}
    end
end
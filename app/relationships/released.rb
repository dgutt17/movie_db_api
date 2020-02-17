class Released < Relationship
    attr_accessor :relationship

    def initialize(movie)
        imdb_id = movie[:tconst]
        release_year = movie[:startYear].to_i

        @relationship = {from: imdb_id, to: release_year, properties: {}}
    end
end
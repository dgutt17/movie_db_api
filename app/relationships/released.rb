class Released < Relationship
    attr_accessor :relationship

    def initialize(content)
        imdb_id = content[:tconst]
        release_year = content[:startYear].to_i

        @relationship = {from: imdb_id, to: release_year, properties: {}}
    end
end
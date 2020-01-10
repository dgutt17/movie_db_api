class Released < Relationship
    attr_accessor :node

    def initialize(movie)
        imdb_id = movie.first
        release_year = movie[5].to_i

        @node = {from: imdb_id, to: release_year}
    end
end
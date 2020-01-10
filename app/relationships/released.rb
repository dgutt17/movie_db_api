class Released < Relationship
    def initialize(movie)
        imdb_id = movie.first
        release_year = movie[5].to_i

        {from: imdb_id, to: release_year}
    end
end
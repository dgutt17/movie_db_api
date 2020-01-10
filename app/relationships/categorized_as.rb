class CategorizedAs < Relationship
    attr_accessor :node
    def initialize(movie)
        imdb_id = movie.first
        
        @node = fetch_genres(movie.last).map do |genre|
            {from: imdb_id, to: genre}
        end
    end

    private

    def parse_genre(genre)
        genre.gsub(/[^0-9a-z ]/i, '')
    end

    def fetch_genres(genres)
        genres.split(",").map {|genre| parse_genre(genre)}
    end
end
class CategorizedAs < Relationship
    attr_accessor :relationships
    def initialize(content)
        imdb_id = content[:tconst]
        
        @relationships = fetch_genres(content[:genres]).map do |genre|
            {from: imdb_id, to: genre, properties: {}}
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
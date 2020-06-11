class CategorizedAs < Relationship
    def relationships
      @relationships ||= parse_genres(args[:genres]).map { |genre| {from: imdb_id, to: genre, properties: {}} }
    end

    def relationship
      nil
    end

    private

    def parse_genres(genres)
      genres.split(",").map { |genre| genre.gsub(/[^0-9a-z ]/i, '') }
    end

    def imdb_id
      @imdb_id ||= args[:tconst]
    end
end
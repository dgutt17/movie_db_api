class Movie < Node
    include Neo4jQueryMethods
    attr_accessor :release_year, :genres, :node

    def initialize(movie)
        @node = {imdb_id: movie.first, title: movie[2].gsub(/'/, '|'), runtime: movie[7].to_i}
        @release_year = create_year_relationship(movie[5])
        @genres = create_genre_relationship(parse_genres(movie))
    end

    private

    def create_genre_relationship(genres)
        relationships = []
        genres.each do |genre|
            relationships << {from: @node[:imdb_id], to: genre}
        end

        return relationships
    end

    def parse_genres(movie)
        movie.last.split(",").map {|genre| genre.gsub(/[^0-9a-z ]/i, '')}
    end

    def create_year_relationship(release_year)
        {from: @node[:imdb_id], to: release_year.to_i}
    end
end
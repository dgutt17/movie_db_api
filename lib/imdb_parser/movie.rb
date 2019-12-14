module ImdbImporter
    class Movie
        include Neo4jQueryMethods
        attr_accessor :release_year, :genres, :node

        def initialize(movie)
            @release_year = create_year_relationship(movie[5])
            @genres = create_genre_relationship(parse_genres(movie))
            @node = {label: 'Movie', body: {imdb_id: movie.first, title: movie[2].gsub(/'/, '|'), runtime: movie[7].to_i}}
        end

        private

        def create_genre_relationship
            relationships = []
            @genres.each do |genre|
                relationships << {from: {id: @node[:imdb_id], label: 'Movie', attr: 'imdb_id'}, to: {id: genre, label: 'Genre', attr: 'name'}, rel_label: 'CATEGORIZED_AS'}
            end

            return relationships
        end

        def parse_genres(movie)
            movie.last.split(",").map {|genre| genre.gsub(/[^0-9a-z ]/i, '')}
        end

        def create_year_relationship(release_year)
            {from: {id: @node[:imdb_id], label: 'Movie', attr: 'imdb_id'}, to: {id: release_year.to_i, label: 'Year', attr: 'value'}, rel_label: 'RELEASED'}
        end
    end
end
module ImdbParser
    class Genre
        def self.match_or_create(genres)
            query_string = String.new
            genres.each do |genre|
                query_string += "MERGE (n:Genre {name: '#{genre}'});"
            end

            query_string
        end
    end
end
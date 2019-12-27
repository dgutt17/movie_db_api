class Genre < Node
    def self.create(genres)
        query_string = String.new
        genres.each_with_index do |genre, index|
            if index != genres.length - 1
                query_string += "(:Genre {name: '#{genre}'}),"
            else
                query_string += "(:Genre {name: '#{genre}'})"
            end
        end

        query_string = 'CREATE ' + query_string + ';'
        $neo4j_session.query(query_string)
    end
end
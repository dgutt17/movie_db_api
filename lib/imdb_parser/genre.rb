module ImdbParser
    class Genre
        def self.match_or_create(genres)
            genres.each do |genre|
                $neo4j_session.query("MERGE (n:Genre {name: '#{genre}'})")
            end
        end
    end
end
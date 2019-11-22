module ImdbParser
    class Genre
        def self.match_or_create(genres)
            driver = Neo4j::Driver.new

            session = driver.session
            genres.each do |genre|
                session.query("Merge (n:Genre {name: #{genre}})")
            end
        end
    end
end
module ImdbParser
    class Genre
        def self.match_or_create(genres)
            driver = Neo4j::Driver.new

            session = driver.session
            session.query('CREATE INDEX ON :Genre(name)')
            genres.each do |genre|
                session.query("MERGE (n:Genre {name: #{genre}})")
            end
        end
    end
end
module ImdbParser
    class Genre
        def self.match_or_create(genres)
            session = NEO4J_DRIVER.session
            session.query('CREATE INDEX ON :Genre(name)')
            genres.each do |genre|
                session.query("MERGE (n:Genre {name: #{genre}})")
            end
        end
    end
end
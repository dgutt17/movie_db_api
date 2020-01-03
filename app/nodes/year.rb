class Year < Node
    def self.create
        year = 1900

        while year <= 2020 do
            $neo4j_session.query("CREATE (n:Year {value: #{year}});")
            year += 1
        end
    end
end
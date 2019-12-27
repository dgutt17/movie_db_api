class Year < Node
    def self.create
        year = 1900

        while year <= 2020 do
            query_str = "CREATE (n:Year {value: #{year}});"
            $neo4j_session.query(query_str)
            year += 1
        end
    end
end
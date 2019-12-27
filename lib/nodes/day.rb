class Day < Node
    def self.create
        day = 1
        while day <= 31 do
            query_str = "CREATE (n:Day {value: #{day}});"
            $neo4j_session.query(query_str)
            day += 1
        end
    end
end
class Day < Node
    def self.create
        day = 1
        query_str = 'CREATE' + ' '
        while day <= 31 do
            $neo4j_session.query("CREATE (n:Day {value: #{day}});")
            day += 1
        end
    end
end
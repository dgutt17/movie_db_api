class Month < Node
    def self.create
        month = 1
        while month <= 12 do
            $neo4j_session.query("CREATE (n:Month {value: #{month}});")
            month += 1
        end
    end
end
module ImdbParser
    class MonthNodes
        def self.create
            driver = Neo4j::Driver.new
            neo4j_session = driver.session

            month = 1

            while month <= 12 do
                query_str = "CREATE (n:Month {value: #{month}});"
                neo4j_session.query(query_str)
                month += 1
            end

        end
    end
end
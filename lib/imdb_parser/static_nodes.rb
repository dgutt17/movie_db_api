module ImdbParser
    module StaticNodes
        def create_month_nodes
            driver = Neo4j::Driver.new
            neo4j_session = driver.session

            month = 1

            while month <= 12 do
                query_str = "CREATE (n:Month {value: #{month}});"
                neo4j_session.query(query_str)
                month += 1
            end
        end

        def create_day_nodes
            driver = Neo4j::Driver.new
            neo4j_session = driver.session

            day = 1

            while day <= 31 do
                query_str = "CREATE (n:Day {value: #{day}});"
                neo4j_session.query(query_str)
                day += 1
            end
        end

        def create_imdb_score_nodes
            driver = Neo4j::Driver.new
            neo4j_session = driver.session

            score = 0

            while score <= 10 do
                query_str = "CREATE (n:Imdb_Score {value: #{score}});"
                neo4j_session.query(query_str)
                score += 1
            end
        end

        def create_year_nodes
            driver = Neo4j::Driver.new
            neo4j_session = driver.session

            year = 1900

            while year <= 2020 do
                query_str = "CREATE (n:Year {value: #{year}});"
                neo4j_session.query(query_str)
                year += 1
            end
        end
    end
end
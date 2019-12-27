class ImdbScore < Node
    def self.create
        score = 0

        while score <= 10 do
            query_str = "CREATE (n:Imdb_Score {value: #{score}});"
            $neo4j_session.query(query_str)
            score += 1
        end
    end
end
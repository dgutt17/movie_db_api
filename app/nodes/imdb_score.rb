class ImdbScore < Node
    def self.create
        score = 0

        while score <= 10 do
            $neo4j_session.query("CREATE (n:#{Labels::IMDB_SCORE} {value: #{score}});")
            score += 1
        end
    end
end
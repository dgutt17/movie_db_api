class Index
    def self.create
        $neo4j_session.query("CREATE INDEX ON :#{Labels::DAY}(value)")
        $neo4j_session.query("CREATE INDEX ON :#{Labels::MONTH}(value)")
        $neo4j_session.query("CREATE INDEX ON :#{Labels::YEAR}(value)")
        $neo4j_session.query("CREATE INDEX ON :#{Labels::IMDB_SCORE}(value)")
        $neo4j_session.query("CREATE INDEX ON :#{Labels::GENRE}(name)")
        $neo4j_session.query("CREATE INDEX ON :#{Labels::MOVIE}(imdb_id)")
        $neo4j_session.query("CREATE INDEX ON :#{Labels::TV_SHOW}(imdb_id)")
        $neo4j_session.query("CREATE INDEX ON :#{Labels::PRINCIPAL}(imdb_id)")
        $neo4j_session.query("CREATE INDEX ON :#{Labels::CONTENT}(imdb_id)")
    end
end
class Index
    def self.create
        $neo4j_session.query('CREATE INDEX ON :Day(value)')
        $neo4j_session.query('CREATE INDEX ON :Month(value)')
        $neo4j_session.query('CREATE INDEX ON :Year(value)')
        $neo4j_session.query('CREATE INDEX ON :Imdb_Score(value)')
        $neo4j_session.query('CREATE INDEX ON :Genre(name)')
        $neo4j_session.query('CREATE INDEX ON :Movie(imdb_id)')
        $neo4j_session.query('CREATE INDEX ON :Tv_Show(imdb_id)')
    end
end
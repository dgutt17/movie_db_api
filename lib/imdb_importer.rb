module ImdbImporter
    def content_check(type)
        if type == 'movie'
            return 1
        elsif type == 'tvSeries' || type == 'tvMiniSeries' || type == 'tvMovie'
            return 2
        else
            return 0
        end
    end

    def create_indices
        $neo4j_session.query('CREATE INDEX ON :Month(value)')
        $neo4j_session.query('CREATE INDEX ON :Day(value)')
        $neo4j_session.query('CREATE INDEX ON :Imdb_Score(value)')
        $neo4j_session.query('CREATE INDEX ON :Year(value)')
        $neo4j_session.query('CREATE INDEX ON :Genre(name)')
        $neo4j_session.query('CREATE INDEX ON :Movie(imdb_id)')
    end
end
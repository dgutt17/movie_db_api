class Index
    QUERY_STRING = 'CREATE INDEX ON :Month(value), :Day(value), :Imdb_Score(value), :Year(value), :Genre(name), :Movie(imdb_id)'.freeze
    def self.create
        $neo4j_session.query(QUERY_STRING)
    end
end
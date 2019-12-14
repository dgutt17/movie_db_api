module Neo4jQueryMethods
    module Movies
        def batch_create_movies(label)
            "UNWIND {list} as row CREATE (n:Movie) SET n+= row"
        end

        def batch_create_genre_relationships
            "UNWIND {list} as row MATCH (from:Movie {imdb_id: row.from}) MATCH (to:Genre {name: row.to}) CREATE (from)-[rel:CATEGORIZED_AS]->(to) SET rel += row"
        end

        def batch_create_year_relationships
            "UNWIND {list} as row MATCH (from:Movie {imdb_id: row.from}) MATCH (to:Year {value: row.to}) CREATE (from)-[rel:RELEASED]->(to) SET rel += row"
        end
    end
end
module Neo4jQueryMethods
    def batch_create_nodes(label)
        "UNWIND {list} as row CREATE (n:#{parse_node_label(label)}) SET n+= row"
    end

    def batch_create_relationships(node_label_one:, node_label_two:, match_obj_one:, match_obj_two:, rel_label:)
        unwind = 'UNWIND {list} as row'
        match_node_one = "MATCH (from:#{parse_node_label(node_label_one)} #{match_obj_one})"
        match_node_two = "MATCH (to:#{parse_node_label(node_label_two)} #{match_obj_two})"
        create_relationship = "CREATE (from)-[rel:#{parse_rel_label(rel_label)}]->(to)"
        increment = 'SET rel += row'

        unwind + match_node_one + match_node_two + create_relationship + increment
    end
    # def batch_create_genre_relationships
    #     "UNWIND {list} as row MATCH (from:Movie {imdb_id: row.from}) MATCH (to:Genre {name: row.to}) CREATE (from)-[rel:CATEGORIZED_AS]->(to) SET rel += row"
    # end

    # def batch_create_year_relationships
    #     "UNWIND {list} as row MATCH (from:Movie {imdb_id: row.from}) MATCH (to:Year {value: row.to}) CREATE (from)-[rel:RELEASED]->(to) SET rel += row"
    # end

    def parse_node_label(label)
        label.titleize.split(' ').join('_')
    end
    
    def parse_rel_label(label)
        label.upcase.split(' ').join('_')
    end
end
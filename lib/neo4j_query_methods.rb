module Neo4jQueryMethods
    def batch_create_nodes
        "UNWIND {list} as row CREATE (n:{node_label}) SET n+= row"
    end

    def batch_create_relationships(attribute_one:, attribute_two:)
        "UNWIND {list} as row MATCH (from:{node_one_label}} {#{attribute_one}: row.from}) MATCH (to:{node_two_label} {#{attribute_two}: row.to}) CREATE (from)-[rel:{rel_label}]->(to) SET rel += row"
    end

    def batch_merge_nodes
        "UNWIND {list} as row MERGE (n:{node_label}) SET n+= row"
    end

    def batch_merge_relationships(attribute_one:, attribute_two:)
        "UNWIND {list} as row MATCH (from:{node_one_label}} {#{attribute_one}: row.from}) MATCH (to:{node_two_label} {#{attribute_two}: row.to}) MERGE (from)-[rel:{rel_label}]->(to) SET rel += row"
    end
end
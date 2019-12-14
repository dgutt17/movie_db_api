module Neo4jQueryMethods
    def batch_create_nodes
        "UNWIND {list} as row CREATE (n:row.label {row.body}) SET n+= row"
    end

    def batch_create_relationships
        "UNWIND {list} as row MATCH (from:row.from.label {row.from.attr:row.from.id}) MATCH (to:row.to.label {row.to.attr: row.to.id}) CREATE (from)-[rel:row.rel_label]->(to) SET rel += row"
    end

    def batch_merge_nodes
        "UNWIND {list} as row MERGE (n:{node_label}) SET n+= row"
    end

    def batch_merge_relationships(attribute_one:, attribute_two:)
        "UNWIND {list} as row MATCH (from:{node_one_label}} {#{attribute_one}: row.from}) MATCH (to:{node_two_label} {#{attribute_two}: row.to}) MERGE (from)-[rel:{rel_label}]->(to) SET rel += row"
    end
end
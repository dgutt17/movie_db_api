module Neo4j
    module QueryMethods
        def batch_create_nodes(label)
            "UNWIND {list} as row CREATE (n:#{parse_node_label(label)} {imdb_id: row.id}) SET n += row.properties return n"
        end

        def batch_create_relationships(args)
            unwind = 'UNWIND {list} as row'
            match_node_one = "MATCH (from:#{parse_node_label(args[:node_label_one])} #{args[:match_obj_one]})"
            match_node_two = "MATCH (to:#{parse_node_label(args[:node_label_two])} #{args[:match_obj_two]})"
            create_relationship = "CREATE (from)-[rel:#{parse_rel_label(args[:rel_label])}]->(to)"

            unwind + ' ' + match_node_one + ' ' + match_node_two + ' ' + ' '+ create_relationship
        end

        def batch_merge_nodes(label)
            "UNWIND {list} as row MERGE (n:#{parse_node_label(label)} {imdb_id: row.id}) ON CREATE SET n += row.properties return n"
        end

        def batch_merge_relationships(args)
            unwind = 'UNWIND {list} as row'
            match_node_one = "MATCH (from:#{parse_node_label(args[:node_label_one])} #{args[:match_obj_one]})"
            match_node_two = "MATCH (to:#{parse_node_label(args[:node_label_two])} #{args[:match_obj_two]})"
            create_relationship = "MERGE (from)-[rel:#{parse_rel_label(args[:rel_label])}]->(to)"

            unwind + ' ' + match_node_one + ' ' + match_node_two + ' ' + ' '+ create_relationship
        end

        def parse_node_label(label)
            label.titleize.split(' ').join('_')
        end
        
        def parse_rel_label(label)
            label.upcase.split(' ').join('_')
        end
    end
end

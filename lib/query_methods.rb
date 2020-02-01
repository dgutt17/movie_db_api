module Neo4j
    module QueryMethods
        def batch_create_nodes(label)
            "UNWIND {list} as row CREATE (n:#{parse_node_label(label)}) SET n+= row return n"
        end

        def batch_create_relationships(args)
            unwind = 'UNWIND {list} as row'
            match_node_one = "MATCH (from:#{parse_node_label(args[:node_label_one])} #{args[:match_obj_one]})"
            match_node_two = "MATCH (to:#{parse_node_label(args[:node_label_two])} #{args[:match_obj_two]})"
            create_relationship = "CREATE (from)-[rel:#{parse_rel_label(args[:rel_label])}]->(to)"
            increment = 'SET rel += row'

            unwind + ' ' + match_node_one + ' ' + match_node_two + ' ' + ' '+ create_relationship + increment
        end

        def parse_node_label(label)
            label.titleize.split(' ').join('_')
        end
        
        def parse_rel_label(label)
            label.upcase.split(' ').join('_')
        end
    end
end

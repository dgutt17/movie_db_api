module Neo4j
    module QueryMethods
        def batch_create_nodes(label)
            "UNWIND {list} as row CREATE (n:#{label}) SET n += row.properties return n"
        end

        def batch_create_relationships(args)
            unwind = 'UNWIND {list} as row'
            match_node_one = "MATCH (from:#{args[:match_one_label]} #{args[:match_obj_one]})"
            match_node_two = "MATCH (to:#{args[:match_two_label]} #{args[:match_obj_two]})"
            create_relationship = "CREATE (from)-[rel:#{args[:rel_label]}]->(to)"
            set_properties = 'SET rel += row.properties'

            unwind + ' ' + match_node_one + ' ' + match_node_two + ' ' + ' '+ create_relationship + ' ' + set_properties
        end

        def batch_merge_nodes(label)
            "UNWIND {list} as row MERGE (n:#{label} {imdb_id: row.id}) ON CREATE SET n += row.properties return n"
        end

        def batch_merge_relationships(args)
            unwind = 'UNWIND {list} as row'
            merge_node_one = "MERGE (from:#{args[:match_one_label]} #{args[:match_obj_one]})"
            merge_node_two = "MERGE (to:#{args[:match_two_label]} #{args[:match_obj_two]})"
            create_relationship = "MERGE (from)-[rel:#{args[:rel_label]}]->(to) ON CREATE SET rel += row.properties return from"

            unwind + ' '  + merge_node_one + ' ' + merge_node_two + ' ' + ' '+ create_relationship 
        end

        def batch_update_nodes(label)
            "UNWIND {list} as row MATCH (n:#{label} {imdb_id: row.id}) SET n += row.properties"
        end

        def batch_update_node_label(new_label:, old_label:)
            "UNWIND {list} as row MATCH (n:#{old_label} {imdb_id: row.id}) SET n :#{new_label}"
        end

        # def parse_node_label(label)
        #     label.titleize.split(' ').join('_')
        # end
        
        # def parse_rel_label(label)
        #     label.upcase.split(' ').join('_')
        # end
    end
end

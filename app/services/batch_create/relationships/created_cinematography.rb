require 'query_methods'
require 'labels'

module BatchCreate
  module Relationships
    class CreatedCinematography
      include Neo4j::QueryMethods
      
      attr_reader :relationships
    
      def initialize
        @relationships = []
      end
    
      def collect(args)
        relationships << ::CreatedCinematography.new(args).relationship
        puts "Created created cinematography relationship #{args[:tconst]} -> #{args[:nconst]}"
      end

      def import
        cypher_object = $neo4j_session.query(batch_merge_relationships(cypher_hash), list: relationships)
        add_to_principal_hash(cypher_object)
        @relationships = []
      end

      private

      def cypher_hash
        {
          match_one_label: Labels::PRINCIPAL,
          match_two_label: Labels::CONTENT,
          match_obj_one: '{imdb_id: row.from}', 
          match_obj_two: '{imdb_id: row.to}', 
          rel_label: Labels::CREATED_CINEMATOGRAPHY
        }
      end

      def add_to_principal_hash(cypher_object)
        parse_cypher_return_node_object(cypher_object)
      end
    end
  end
end
require 'query_methods'
require 'labels'

module BatchCreate
  module Relationships
    class Produced
      include Neo4j::QueryMethods
      
      attr_reader :relationships
    
      def initialize
        @relationships = []
      end
    
      def collect(args)
        relationships << ::Produced.new(args).relationship
        puts "Created produced relationship #{args[:tconst]} -> #{args[:nconst]}"
      end

      def import
        cypher_object = $neo4j_session.query(batch_merge_relationships(cypher_hash), list: relationships)
        @relationships = []

        cypher_object
      end

      private

      def cypher_hash
        {
          match_one_label: Labels::PRINCIPAL,
          match_two_label: Labels::CONTENT,
          match_obj_one: '{imdb_id: row.from}', 
          match_obj_two: '{imdb_id: row.to}', 
          rel_label: Labels::PRODUCED
        }
      end
    end
  end
end
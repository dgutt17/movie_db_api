require 'query_methods'
require 'labels'

module BatchCreate
  module Relationships
    class ActedIn
      include Neo4j::QueryMethods
      
      attr_reader :relationships, :prinicpal_hash
    
      def initialize
        @relationships = []
        @prinicpal_hash = {}
      end
    
      def collect(args)
        relationships << ::ActedIn.new(args).relationship
        puts "Created acted in relationship #{args[:tconst]} -> #{args[:nconst]}"
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
          rel_label: Labels::ACTED_IN
        }
      end
    end
  end
end
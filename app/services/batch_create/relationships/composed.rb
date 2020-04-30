require 'query_methods'
require 'labels'

module BatchCreate
  module Relationships
    class Composed
      include Neo4j::QueryMethods
      
      attr_reader :relationships
    
      def initialize
        @relationships = []
      end
    
      def collect(args)
        relationships << ::Composed.new(args).relationship
        puts "Created composed relationship #{args[:tconst]} -> #{args[:nconst]}"
      end

      def import
        $neo4j_session.query(batch_merge_relationships(cypher_hash), list: relationships)
        @relationships = []
      end

      private

      def cypher_hash
        {
          match_one_label: Labels::PRINCIPAL,
          match_two_label: Labels::MOVIE,
          match_obj_one: '{imdb_id: row.from}', 
          match_obj_two: '{imdb_id: row.to}', 
          rel_label: Labels::COMPOSED
        }
      end
    end
  end
end
require 'query_methods'
require 'labels'

module BatchCreate
  module Relationships
    class Composed
      include Neo4j::QueryMethods
      
      attr_reader :relationships, :content_hash
    
      def initialize(content_hash)
        @content_hash = content_hash
        @relationships = []
      end
    
      def collect(args)
        relationships << ::Composed.new(args).relationship if content_hash[relationship[:to].to_sym]
        puts "Created composed relationship #{args[:tconst]} -> #{args[:nconst]}"
      end

      def import
        $neo4j_session.query(batch_create_relationships(cypher_hash), list: relationships)
        @relationships = []
      end

      private

      def cypher_hash
        {
          match_obj_one: '{imdb_id: row.from}', 
          match_obj_two: '{imdb_id: row.to}', 
          rel_label: Labels::COMPOSED
        }
      end
    end
  end
end
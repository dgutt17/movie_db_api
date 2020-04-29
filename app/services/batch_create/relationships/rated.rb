require 'query_methods'
require 'labels'

module BatchCreate
  module Relationships
    class Rated
      include Neo4j::QueryMethods
      
      attr_reader :relationships
    
      def initialize
        # @content_hash = content_hash
        @relationships = []
      end
    
      def collect(args)
        relationships << ::Rated.new(args).relationship
        puts "Created rated relationship #{args[:tconst]} -> #{args[:averageRating]}"
      end

      def import
        $neo4j_session.query(batch_create_relationships(cypher_hash), list: relationships)
        @relationships = []
      end

      private

      def cypher_hash
        {
          match_one_label: Labels::CONTENT,
          match_two_label: Labels::IMDB_SCORE,
          match_obj_one: '{imdb_id: row.from}', 
          match_obj_two: '{value: row.to}', 
          rel_label: Labels::RATED
        }
      end
    end
  end
end
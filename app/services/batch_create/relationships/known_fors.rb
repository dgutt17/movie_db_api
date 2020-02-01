require 'query_methods'

module BatchCreate
  module Relationships
    class KnownFors
      include Neo4j::QueryMethods

      attr_reader :relationships, :content_hash
    
      def initialize(content_hash)
        @content_hash = content_hash
        @relationships = []
      end
    
      def collect(args)
        KnownFor.new(args).relationships.each do |relationship|
          relationships << relationship if content_hash[relationship[:to].to_sym]
        end
        puts "Created known for relationship for: #{args[:nconst]}"
      end

      def import
        $neo4j_session.query(batch_create_relationships(cypher_hash), list: relationships)
        @relationships = []
      end

      module Labels
        PRINCIPAL = 'Principal'.freeze
        MOVIE = 'Movie'.freeze
        KNOWNFOR = 'Known_For'.freeze
      end

      private

      def cypher_hash
        {
          node_label_one: Labels::PRINCIPAL,
          node_label_two: Labels::MOVIE, 
          match_obj_one: '{imdb_id: row.from}', 
          match_obj_two: '{imdb_id: row.to}', 
          rel_label: Labels::KNOWNFOR
        }
      end
    end
  end
end
# require 'query_methods'
# require 'labels'

module BatchCreate
  module Relationships
    class KnownFors
      include Neo4j::QueryMethods
      include ImporterParsingMethods

      attr_reader :relationships, :content_hash
    
      def initialize(content_hash)
        @content_hash = content_hash
        @relationships = []
      end
    
      def collect(args)
        KnownFor.new(args).relationships.each do |relationship|
          relationships << relationship if add_known_for?(relationship)
        end
        puts "Created known for relationship for: #{args[:nconst]}"
      end

      def import
        $neo4j_session.query(batch_merge_relationships(cypher_hash), list: relationships)
        @relationships = []
      end

      private

      def cypher_hash
        {
          match_one_label: Labels::PRINCIPAL,
          match_two_label: Labels::CONTENT,
          match_obj_one: '{imdb_id: row.from}', 
          match_obj_two: '{imdb_id: row.to}', 
          rel_label: Labels::KNOWN_FOR
        }
      end

      def add_known_for?(relationship)
        content = content_hash[relationship[:to]]

        content.present? ? can_add_data?(content) : false
      end
    end
  end
end
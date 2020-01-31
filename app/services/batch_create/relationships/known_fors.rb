module BatchCreate
  module Relationships
    class KnownFors
      include Neo4j::QueryMethods

      attr_reader :relationships
    
      def initalize
        @relationships = []
      end
    
      def collect(args)
        relationships << KnownFor.new(args).relationships
      end

      def import
        $neo4j_session.query(batch_create_relationships(cypher_hash), list: relationships.flatten!)
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
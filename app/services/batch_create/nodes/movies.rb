require 'query_methods'

module BatchCreate
  module Nodes
    class Movies
      include Neo4j::QueryMethods
      include ImporterParsingMethods

      attr_reader :nodes

      def initialize
        @nodes = []
      end

      def collect(args)
        nodes << Movie.new(args).node if parse_type(args[:titleType]) == :movie
        puts "Created movie: #{args[:tconst]}"
      end

      def import
        cypher_obj = $neo4j_session.query(batch_create_nodes(labels), list: nodes)
        @nodes = []

        cypher_obj
      end

      private

      def labels
        "#{Labels::CONTENT}:#{Labels::MOVIE}"
      end
    end
  end
end
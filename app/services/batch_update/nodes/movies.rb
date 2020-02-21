require 'query_methods'

module BatchUpdate
  module Nodes
    class Movies
      include Neo4j::QueryMethods
      include ImporterParsingMethods

      attr_reader :nodes

      def initialize
        @nodes = []
      end

      def collect(args)
        nodes << Movie.new(args).node
        puts "Updated movie: #{args[:tconst]}"
      end

      def import
        $neo4j_session.query(batch_update_nodes(Labels::MOVIE), list: nodes)
        @nodes = []
      end
    end
  end
end
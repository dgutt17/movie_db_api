require 'query_methods'

module BatchCreate
  module Nodes
    class Movies
      include Neo4j::QueryMethods

      attr_reader :nodes

      def initialize
        @nodes = []
      end

      def collect(args)
        nodes << Movie.new(args).node
        puts "Created movie: #{args[:tconst]}"
      end

      def import
        $neo4j_session.query(batch_create_nodes(Labels::MOVIE), list: nodes)
        @nodes = []
      end
    end
  end
end
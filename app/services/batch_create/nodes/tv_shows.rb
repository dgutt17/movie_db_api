require 'query_methods'
require 'labels'

module BatchCreate
  module Nodes
    class TvShows
      include Neo4j::QueryMethods

      attr_reader :nodes

      def initialize
        @nodes = []
      end

      def collect(args)
        nodes << TvShow.new(args).node
        puts "Created principal: #{args[:nconst]}, #{args[:primaryName]}"
      end

      def import
        $neo4j_session.query(batch_create_nodes(Labels::TVSHOW), list: nodes)
        @nodes = []
      end

    end
  end
end
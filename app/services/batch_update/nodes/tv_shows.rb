require 'query_methods'
require 'labels'

module BatchUpdate
  module Nodes
    class TvShow
      include Neo4j::QueryMethods
      include ImporterParsingMethods

      attr_reader :nodes

      def initialize
        @nodes = []
      end

      def collect(args)
        nodes << TvShow.new(args).node
        puts "Updated TvShow: #{args[:tconst]}"
      end

      def import
        $neo4j_session.query(batch_update_nodes(Labels::TV_SHOW), list: nodes)
        @nodes = []
      end

    end
  end
end
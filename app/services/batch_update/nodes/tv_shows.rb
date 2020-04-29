require 'query_methods'
require 'labels'

module BatchUpdate
  module Nodes
    class TvShows
      include Neo4j::QueryMethods
      include ImporterParsingMethods

      attr_reader :nodes

      def initialize
        @nodes = []
      end

      def collect(args)
        return  if parse_type(args[:titleType]) != :tv_show
        nodes << TvShow.new(args).node
        puts "Created Tv Show: #{args[:nconst]}, #{args[:primaryName]}"
      end

      def import
        $neo4j_session.query(batch_update_node_label(new_label: tv_show_label, old_label: content_label), list: nodes)
        $neo4j_session.query(batch_update_nodes(labels), list: nodes)
        @nodes = []
      end

      private

      def labels
        "#{content_label}:#{tv_show_label}"
      end

      def content_label
        Labels::CONTENT
      end

      def tv_show_label
        Labels::TV_SHOW
      end
    end
  end
end
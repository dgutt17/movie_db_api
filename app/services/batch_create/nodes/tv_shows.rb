# require 'query_methods'
# require 'labels'

module BatchCreate
  module Nodes
    class TvShows
      include Neo4j::QueryMethods
      include ImporterParsingMethods

      attr_reader :nodes

      def initialize
        @nodes = []
      end

      def collect(args)
        nodes << TvShow.new(args).node if parse_type(args[:titleType]) == :tv_show
        puts "Created principal: #{args[:nconst]}, #{args[:primaryName]}"
      end

      def import
        cypher_obj = $neo4j_session.query(batch_create_nodes(labels), list: nodes)
        @nodes = []

        cypher_obj
      end

      private

      def labels
        "#{Labels::CONTENT}:#{Labels::TV_SHOW}"
      end

    end
  end
end
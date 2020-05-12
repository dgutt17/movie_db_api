# require 'query_methods'
# require 'labels'

module BatchUpdate
  module Nodes
    class Principals
      include Neo4j::QueryMethods
      include ImporterParsingMethods

      attr_reader :nodes

      def initialize
        @nodes = []
      end

      def collect(args)
        nodes << Principal.new(args).node
        puts "Updated principal: #{args[:nconst]}, #{args[:primaryName]}"
      end

      def import
        $neo4j_session.query(batch_update_nodes(Labels::PRINCIPAL), list: nodes)
        @nodes = []
      end
    end
  end
end
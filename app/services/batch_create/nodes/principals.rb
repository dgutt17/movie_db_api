require 'query_methods'

module BatchCreate
  module Nodes
    class Principals
      include Neo4j::QueryMethods

      attr_reader :nodes

      def initialize
        @nodes = []
      end

      def collect(args)
        nodes << Principal.new(args).node
        puts "Created principal: #{args[:nconst]}, #{args[:primaryName]}"
      end

      def import
        $neo4j_session.query(batch_create_nodes('Principal'), list: nodes)
        @nodes = []
      end

    end
  end
end
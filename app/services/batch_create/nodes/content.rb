require 'query_methods'
require 'labels'

module BatchCreate
  module Nodes
    class Content
      include Neo4j::QueryMethods
      include ImporterParsingMethods

      attr_reader :nodes

      def initialize
        # @content_hash = content_hash
        @nodes = []
      end

      def collect(args)
        nodes << ::Content.new(args).node
        puts "New Content: #{args[:tconst]}"
      end

      def import
        cypher_obj = $neo4j_session.query(batch_create_nodes(Labels::CONTENT), list: nodes)
        @nodes = []

        cypher_obj
      end
    end
  end
end
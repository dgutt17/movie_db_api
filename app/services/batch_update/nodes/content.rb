require 'query_methods'
require 'labels'

module BatchUpdate
  module Nodes
    class Content
      include Neo4j::QueryMethods
      include ImporterParsingMethods

      attr_reader :nodes, :content_hash

      def initialize(content_hash)
        @content_hash = content_hash
        @nodes = []
      end

      def collect(args)
        nodes << Content.rating_properties(args) if content_hash[args[:tconst].to_sym]
        puts "Updated Content: #{args[:tconst]}"
      end

      def import
        $neo4j_session.query(batch_update_nodes(Labels::CONTENT), list: nodes)
        @nodes = []
      end
    end
  end
end
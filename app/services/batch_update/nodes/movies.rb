# require 'query_methods'

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
        return if parse_type(args[:titleType]) != :movie
        nodes << Movie.new(args).node
        puts "Created movie: #{args[:tconst]}"
      end

      def import
        $neo4j_session.query(batch_update_node_label(new_label: movie_label, old_label: content_label), list: nodes)
        $neo4j_session.query(batch_update_nodes(labels), list: nodes)
        @nodes = []
      end

      private

      def labels
        "#{content_label}:#{movie_label}"
      end

      def content_label
        Labels::CONTENT
      end

      def movie_label
        Labels::MOVIE
      end
    end
  end
end
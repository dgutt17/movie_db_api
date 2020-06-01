# require 'query_methods'

module BatchCreate
  class Nodes
    include Neo4j::QueryMethods
    include ImporterParsingMethods

    attr_reader :nodes, :type

    def initialize(type:)
      @nodes = []
      @type = type
    end

    def collect(args)
      nodes << klass.new(args).node if parse_type(args[:titleType]) == type
      puts "Created movie: #{args[:tconst]}"
    end

    def import
      cypher_obj = $neo4j_session.query(batch_merge_nodes(labels), list: nodes)
      @nodes = []

      cypher_obj
    end

    private

    def labels
      "#{Labels::CONTENT}:#{Labels::MOVIE}"
    end

    def klass
      @klass ||= type.to_s.split('_').map{|word| word.capitalize}.join('').constantize
    end
  end
end
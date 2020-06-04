module BatchMerge
  class Nodes
    include Neo4j::QueryMethods
    include ImporterParsingMethods

    attr_reader :nodes, :type

    def initialize(type:)
      @nodes = []
      @type = type
    end

    def collect(args)
      if args[:titleType].present?
        nodes << klass.new(args).node if parse_type(args[:titleType]) == type
      else
        nodes << klass.new(args).node
      end
      puts print_statement(args)
    end

    def import
      cypher_obj = $neo4j_session.query(batch_merge_nodes(labels), list: nodes)
      @nodes = []

      cypher_obj
    end

    private

    def labels
      return "#{Labels::CONTENT}:#{Labels::MOVIE}" if type == :movie
      return "#{Labels::CONTENT}:#{Labels::TV_SHOW}" if type == :tv_show
      return "#{Labels::PRINCIPAL}" if type == :principal
    end

    def klass
      @klass ||= type.to_s.split('_').map{|word| word.capitalize}.join('').constantize
    end

    def print_statement(args)
      return "Upserted movie #{args[:tconst]}" if type == :movie
      return "Upserted tv_show #{args[:tconst]}" if type == :tv_show
      return "Upserted principal #{args[:nconst]}" if type == :principal
    end
  end
end
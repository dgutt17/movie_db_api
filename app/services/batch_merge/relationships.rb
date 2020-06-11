module BatchMerge
  class Relationships
    include Neo4j::QueryMethods
    include ImporterParsingMethods

    attr_reader :relationships, :type, :node_one_type, :node_two_type
  
    def initialize(type:, node_one_type:, node_two_type:)
      @type = type
      @node_one_type = node_one_type
      @node_two_type = node_two_type
      @relationships = []
    end
  
    def collect(args)
      klass_instance = klass.new(args)

      relationships << (klass_instance.try(:relationship) || klass_instance.try(:relationships))
      puts put_statement(args)
    end

    def import
      $neo4j_session.query(batch_merge_relationships(cypher_hash), list: relationships.flatten)
      @relationships = []
    end

    private

    def klass
      @klass ||= type.to_s.split('_').map{|word| word.capitalize }.join('').constantize
    end

    def rel_label
      @rel_label ||= "Labels::#{type.to_s.upcase}".constantize
    end

    def put_statement(args)
      @put_statement ||= puts "Created #{print_friendly_type} relationship #{args[:tconst]} -> #{args[:nconst]}"
    end

    def print_friendly_type
      @print_friendly_type ||= type.to_s.split('_').join(' ')
    end

    def node_one_label
      @node_one_label ||= "Labels::#{node_one_type.to_s.upcase}".constantize
    end

    def node_two_label
      @node_two_label ||= "Labels::#{node_two_type.to_s.upcase}".constantize
    end

    def cypher_hash
      {
        match_one_label: node_one_label,
        match_two_label: node_two_label,
        match_obj_one: '{imdb_id: row.from}', 
        match_obj_two: '{name: row.to}', 
        rel_label: rel_label
      }
    end
  end
end
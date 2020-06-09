module BatchMerge
  class Relationships
    include Neo4j::QueryMethods
    include ImporterParsingMethods
    include Labels
    
    attr_reader :relationships, :type
  
    def initialize(type:)
      @type = type
      @relationships = []
    end
  
    def collect(args)
      relationships << klass.new(args).relationships
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
      @rel_label ||= type.to_s.upcase.constantize
    end

    def put_statement(args)
      @put_statement ||= puts "Created #{print_friendly_type} relationship #{args[:tconst]} -> #{args[:nconst]}"
    end

    def print_friendly_type
      @print_friendly_type ||= type.to_s.split('_').join(' ')
    end

    def cypher_hash
      {
        match_one_label: Labels::CONTENT,
        match_two_label: Labels::GENRE,
        match_obj_one: '{imdb_id: row.from}', 
        match_obj_two: '{name: row.to}', 
        rel_label: rel_label
      }
    end
  end
end
module BatchMerge
  class Relationships
    include Neo4j::QueryMethods
    include ImporterParsingMethods
    
    attr_reader :relationships, :type
  
    def initialize(type:)
      @type = type
      @relationships = []
    end
  
    def collect(args)
      relationships << ::CategorizedAs.new(args).relationships
      puts "Created categorized as relationship #{args[:tconst]} -> #{args[:nconst]}"
    end

    def import
      $neo4j_session.query(batch_create_relationships(cypher_hash), list: relationships.flatten)
      @relationships = []
    end

    private

    def cypher_hash
      {
        match_one_label: Labels::CONTENT,
        match_two_label: Labels::GENRE,
        match_obj_one: '{imdb_id: row.from}', 
        match_obj_two: '{name: row.to}', 
        rel_label: Labels::CATEGORIZED_AS
      }
    end
  end
end
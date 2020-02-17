require 'query_methods'
require 'labels'

module BatchCreate
  module Relationships
    class Released
      include Neo4j::QueryMethods
      include ImporterParsingMethods
      
      attr_reader :movie_relationships, :tv_show_relationships
    
      def initialize
        @movie_relationships = []
        @tv_show_relationships = []
      end
    
      def collect(args)
        movie_relationships << ::Released.new(args).relationship if parse_type(args[:titleType]) == :movie
        tv_show_relationships << ::Released.new(args).relationship if parse_type(args[:titleType]) == :tv_show
        puts "Created released relationship #{args[:tconst]} -> #{args[:nconst]}"
      end

      def import
        $neo4j_session.query(batch_create_relationships(cypher_hash_movie), list: movie_relationships.flatten)
        $neo4j_session.query(batch_create_relationships(cypher_hash_tv_show), list: tv_show_relationships.flatten)
        @movie_relationships = []
        @tv_show_relationships = []
      end

      private

      def cypher_hash_movie
        {
          match_one_label: Labels::MOVIE,
          match_two_label: Labels::YEAR,
          match_obj_one: '{imdb_id: row.from}', 
          match_obj_two: '{value: row.to}', 
          rel_label: Labels::RELEASED
        }
      end

      def cypher_hash_tv_show
        {
          match_one_label: Labels::TV_SHOW,
          match_two_label: Labels::YEAR,
          match_obj_one: '{imdb_id: row.from}', 
          match_obj_two: '{value: row.to}', 
          rel_label: Labels::RELEASED
        }
      end
    end
  end
end
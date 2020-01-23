require 'query_methods'
class TitleBasicsImporter
    include Neo4j::QueryMethods

    attr_accessor :file_path, :movies, :categorized_as_rels_movie, :released_rels_movie, :count, 
                  :tv_shows, :headers, :categorized_as_rels_tv, :released_rels_tv

    def initialize
        @file_path = ENV['TITLE_BASICS_PATH'] 
        @movies = []
        @categorized_as_rels_movie = []
        @released_rels_movie = []
        @tv_shows = []
        @categorized_as_rels_tv = []
        @released_rels_tv = []
        @count = 0
    end

    def run
        start_time = Time.now
        File.open(file_path) do |file|
            parse_title_basics(file)
        end
        # Importing the remaining movies and relationships.
        import if @movies.length > 0
        puts "Time to finish: #{Time.now - start_time}"
    end

    module Labels
        MOVIE = 'Movie'.freeze
        CATEGORIZED_AS = 'CATEGORIZED_AS'.freeze
        RELEASED = 'RELEASED'.freeze
        GENRE = 'Genre'.freeze
        YEAR = 'Year'.freeze
        TVSHOW = 'TvShow'.freeze

        def self.content_label(type)
            type == :movie ? MOVIE : TVSHOW
        end
    end

    private

    def parse_title_basics(file)
        file.each_with_index do |row, index|
            if index == 0
                @headers = row.split("\t").map{|header| header.gsub("\n","").to_sym}
                next
            end
            parse_content(row)
            import if @count == 50000
        end
    end

    def parse_row(row)
        parsed_row = {}
        row = row.split("\t")
        headers.each_with_index do |header, index|
            parsed_row[header] = row[index]
        end

        parsed_row
    end

     def parse_content(row)
        row = parse_row(row)
        content = Content.new(row).content_node
        add_data(row, content) if can_add_data?(row, content[:type])
     end

     def can_add_data?(row, content_type)
        not_adult_content?(row) && not_before_1950?(row) && content_type != :nothing
     end

     def not_adult_content?(row)
        row[:isAdult] == '0'
     end

     def not_before_1950?(row)
        row[:startYear].to_i >= 1950
     end

     def add_data(row, content)
         content[:type] == :movie ? add_movie(content, row) : add_tv_show(content, row)
         @count += 1
     end
    
    def add_movie(movie, row)
        movies << movie[:node]
        add_categorized_as(row, movie[:type])
        add_released(row, movie[:type])
        puts "Created #{movie[:imdb_id]} as a Movie Node"
    end
    
    def add_categorized_as(row, type)
         if type == :movie
            categorized_as_rels_movie << CategorizedAs.new(row).node
         else
            categorized_as_rels_tv << CategorizedAs.new(row).node
         end
    end
    
    def add_released(row, type)
      if type == :movie
         released_rels_movie << Released.new(row).node
      else
         released_rels_tv << Released.new(row).node
      end
    end

     def add_tv_show(tv_show, row)
        tv_shows << tv_show[:node]
        add_categorized_as(row, tv_show[:type])
        add_released(row, tv_show[:type])
        puts "Created #{tv_show[:imdb_id]} as a TV show Node"
     end

     def import
        @count = 0
        puts "unwinding.............................................."
        import_movies
        import_tv_shows
        empty_arrays
        puts "done..................................................."
     end

     def empty_arrays
        @movies = []
        @categorized_as_rels_movie = []
        @released_rels_movie = []
        @tv_shows = []
        @categorized_as_rels_tv = []
        @released_rels_tv = []
     end

     def import_movies
         import_nodes(:movie)
         import_categorized_as_rels(:movie)
         import_released_rels(:movie)
     end

     def import_tv_shows
         import_nodes(:tv_show)
         import_categorized_as_rels(:tv_show)
         import_released_rels(:tv_show)
     end

     def import_nodes(type)
      if type == :movie
         $neo4j_session.query(batch_create_nodes('Movie'), list: @movies)
      else
         $neo4j_session.query(batch_create_nodes('TvShow'), list: @tv_shows)
      end
     end

     def import_categorized_as_rels(type)
         if type == :movie
            $neo4j_session.query(categorized_as_query(type), list: @categorized_as_rels_movie.flatten)
        else
            $neo4j_session.query(categorized_as_query(type), list: @categorized_as_rels_tv.flatten)
        end
     end

     def import_released_rels(type)
         if type == :movie
            $neo4j_session.query(released_query(type), list: @released_rels_movie)
        else
            $neo4j_session.query(released_query(type), list: @released_rels_tv)
        end
     end

     def categorized_as_query(type)
        batch_create_relationships(categorized_as_hash(type))
     end

     def categorized_as_hash(type)
        {
            node_label_one: Labels.content_label(type),
            node_label_two: Labels::GENRE, 
            match_obj_one: '{imdb_id: row.from}', 
            match_obj_two: '{name: row.to}', 
            rel_label: Labels::CATEGORIZED_AS
        }
     end

     def released_query(type)
        batch_create_relationships(released_hash(type))
     end

     def released_hash(type)
        {
            node_label_one: Labels.content_label(type), 
            node_label_two: Labels::YEAR, 
            match_obj_one: '{imdb_id: row.from}', 
            match_obj_two: '{value: row.to}', 
            rel_label: Labels::RELEASED
        }
     end
end
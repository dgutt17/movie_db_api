require 'query_methods'
class TitleBasicsImporter
    include Neo4j::QueryMethods

    attr_accessor :file_path, :movies, :categorized_as_rels, :released_rels, :count, :headers, :tv_shows

    def initialize
        @file_path = ENV['TITLE_BASICS_PATH'] 
        @movies = []
        @categorized_as_rels = []
        @released_rels = []
        @tv_shows = []
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
        A = 'RELEASED'.freeze
        GENRE = 'Genre'.freeze
        YEAR = 'Year'.freeze
    end

    private

    def parse_title_basics(file)
        file.each_with_index do |row, index|
            if index == 0
                headers = row.split("\t").map{|header| header.to_sym}
                next
            end
            parse_content(row)
            import if @count == 50000
        end
    end

    def parse_row(row)
        parsed_row = {}
        headers.each_with_index do |header, index|
            parsed_row[header] = row[index]
        end

        parsed_row
    end

     def parse_content(row)
        row = parse_row(row)
        content = Content.new(row)
        add_data(row, content[:node]) if can_add_data?(row, content[:type])
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

     def add_data(row, node)
        add_content(node)
        add_categorized_as(row)
        add_released(row)
        @count += 1
     end

     def add_content(node)
        node[:type] == :movie ? add_movie(node) : add_tv_show(node)
    end
    
    def add_movie(movie)
        movies << movie
        puts "Created #{content[:tconst]} as a Movie Node"
    end
    
    def add_categorized_as(row)
        categorized_as_rels << CategorizedAs.new(row).node
    end
    
    def add_released(row)
        released_rels << Released.new(row).node
    end

     def add_tv_show(tv_show)
        tv_shows << tv_show
        puts "Created #{row[:tconst]} as a TV show Node"
     end

     def import
        @count = 0
        puts "unwinding.............................................."
        import_movies
        import_categorized_as_rels
        import_released_rels
        @movies = []
        @categorized_as_rels = []
        @released_rels = []
        @tv_shows = []
        puts "done..................................................."
     end

     def import_movies
        $neo4j_session.query(batch_create_nodes('Movie'), list: @movies)
     end

     def import_tv_shows
        $neo4j_session.query(batch_create_nodes('Movie'), list: @movies)
     end

     def import_categorized_as_rels
        $neo4j_session.query(categorized_as_query, list: @categorized_as_rels.flatten)
     end

     def import_released_rels
        $neo4j_session.query(released_query, list: @released_rels)
     end

     def categorized_as_query
        batch_create_relationships(categorized_as_hash)
     end

     def categorized_as_hash
        {
            node_label_one: Labels::MOVIE, 
            node_label_two: Labels::GENRE, 
            match_obj_one: '{imdb_id: row.from}', 
            match_obj_two: '{name: row.to}', 
            rel_label: Labels::CATEGORIZED_AS
        }
     end

     def released_query
        batch_create_relationships(released_hash)
     end

     def released_hash
        {
            node_label_one: Labels::MOVIE, 
            node_label_two: Labels::YEAR, 
            match_obj_one: '{imdb_id: row.from}', 
            match_obj_two: '{value: row.to}', 
            rel_label: Labels::A
        }
     end

end
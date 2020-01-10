require 'neo4j_query_methods'
class TitleBasicsImporter
    include Neo4jQueryMethods

    attr_accessor :file, :movies, :categorized_as_rels, :released_rels, :count

    def initialize
        @file = ENV["TITLE_BASICS_PATH"] 
        @movies = Array.new
        @categorized_as_rels = Array.new
        @released_rels = Array.new
        @count = 0
    end

    def run
        start_time = Time.now
        File.open(file) do |file|
            parse_title_basics(file)

            # Importing the remaining movies and relationships.
            import if movies.length > 0
        end
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
            next if index == 0
            parse_content(row)
            import if @count == 50000
        end
    end

    def parse_row(row)
        row = row.split("\t")
    end
    
    def content_check(type)
        if type == 'movie'
             return :movie
         elsif type == 'tvSeries' || type == 'tvMiniSeries' || type == 'tvMovie'
            return :tv_show
         else
            return :nothing
         end
     end

     def parse_content(row)
        row = parse_row(row)
        add_data(row) if can_add_data?(row)
     end

     def can_add_data?(row)
        not_adult_content?(row) && not_before_1950?(row)
     end

     def not_adult_content?(row)
        row[4] == '0'
     end

     def not_before_1950?(row)
        row[5].to_i >= 1950
     end

     def add_data(row)
        add_content(row, content_check(row[1]))
        add_categorized_as(row)
        add_released(row)
        @count += 1
     end

     def add_content(row, content)
        if content == :movie
            add_movie(row)
        elsif content == :tv_show
            add_tv_show(row)
        end
    end
    
    def add_movie(row)
        movies << Movie.new(row).node
        puts "Created #{row[2]} as a Movie Node"
    end
    
    def add_categorized_as(row)
        categorized_as_rels << CategorizedAs.new(row).node
    end
    
    def add_released(row)
        released_rels << Released.new(row).node
    end

     def add_tv_show(row)
        # tv_content = TVContent.new(row)
        puts "Created #{row[2]} as a TV show Node"
     end

     def import
        @count = 0
        puts "unwinding.............................................."
        import_movies
        import_categorized_as_rels
        import_released_rels
        movies = []
        categorized_as_rels = []
        released_rels = []
        puts "done..................................................."
     end

     def import_movies
        $neo4j_session.query(batch_create_nodes('Movie'), list: movies)
     end

     def import_categorized_as_rels
        $neo4j_session.query(categorized_as_query, list: categorized_as_rels.flatten)
     end

     def import_released_rels
        $neo4j_session.query(released_query, list: released_rels)
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
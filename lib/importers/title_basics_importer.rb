class TitleBasicsImporter
    include Neo4jQueryMethods

    attr_accessor :file, :movies, :categorized_as_rels, :released_rels, :count

    def intialize
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
            import if count == 50000
        end
        puts "Time to finish: #{Time.now - start_time}"
    end

    private

    def parse_title_basics(file)
        file.each_with_index do |row, index|
            next if index == 0
            parse_content(row)
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
        add_data(row) if can_add_content?(row)
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
        add_content(row)
        add_categorized_as(row)
        add_released(row)
        count += 1
     end

     def add_content(row)
        if content == :movie
            add_movie(row)
        elsif content == :tv_show
            add_tv_show(row)
        end
    end
    
    def add_movie(row)
        movies << Movie.new(row)
        puts "Created #{row[2]} as a Movie Node"
    end
    
    def add_categorized_as(row)
        categorized_as_rels << CategorizedAs.new(row)
    end
    
    def add_released(row)
        released_rels << Released.new(row)
    end

     def add_tv_show(row)
        # tv_content = TVContent.new(row)
        puts "Created #{row[2]} as a TV show Node"
     end

     def import
        count = 0
        puts "unwinding.............................................."
        $neo4j_session.query(create_node_str, list: movie_nodes)
        $neo4j_session.query(create_rel_str, list: movie_to_genre_rel.flatten)
        $neo4j_session.query(create_rel_str_2, list: movie_to_year_rel)
        movie_nodes = []
        movie_to_genre_rel = []
        movie_to_year_rel = []
        puts "done..................................................."
     end

     def import_movies
        $neo4j_session.query(batch_create_nodes('Movie'), list: movies)
     end


end
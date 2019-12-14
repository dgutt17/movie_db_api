module ImdbImporter
    class BulkUpdateNodes
        include Neo4jQueryMethods

        attr_accessor :file_path, :nodes, :content, :method

        def initialize(file_path:, content:)
            @file_path = file_path
            @nodes = []
            @relationships = []
            @count = 0
            @method = content_to_be_created(content)
        end

        def run
            start_time = Time.now
            File.open(@file_path) do |file|
                file.each_with_index do |row, index|
                    self.send(@method, parse_row(row))
                end
            end
            puts "Time to finish: #{Time.now - start_time}"
        end

        def content_to_be_created(content)
            case content
            when :show
                :create_show
            when :genre
                # Call Genre
            when :crew
                # Call Crew
            end
        end

        def create_show(row)
            if row[4] == '0' && index > 0 && row[5].to_i >= 1950
                show_content = show_content_type(row[1])
                if show_content == 1
                    create_movie
                elsif show_content == 2
                    # tv_content = TVContent.new(row)
                end
                unwind
            end
        end

        def parse_row(row)
            row = row.split("\t")

            row
        end

        def show_content_type(type)
            if type == 'movie'
                return 1
            elsif type == 'tvSeries' || type == 'tvMiniSeries' || type == 'tvMovie'
                return 2
            else
                return 0
            end
        end

        def create_movie
            @count += 1
            movie = ImdbImporter::Movie.new(row)
            @nodes << movie.node
            @relationships << movie.genres
            @relationships << movie.release_year
            puts "Created #{row[2]} as a Movie Node"
        end

        def unwind
            if count == 50000
                @count = 0
                puts "unwinding.............................................."
                $neo4j_session.query(batch_create_nodes, list: @nodes)
                $neo4j_session.query(batch_create_relationships, list: @relationships.flatten)
                @nodes = []
                @relationships = []
                puts "done..................................................."
            end
        end

    end
end
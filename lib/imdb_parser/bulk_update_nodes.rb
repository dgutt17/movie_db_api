module ImdbImporter
    class BulkUpdateNodes
        include Neo4jQueryMethods
        include ImdbImporter

        attr_accessor :file_path, :movies, :actors, :genres, :directors, :writers

        def initialize(file_path:)
            @file_path = file_path
            @movies, @genres, @actors, @directors, @writers = []
            @count = 0
        end

        def run
            start_time = Time.now
            File.open(file_path) do |file|
                file.each_with_index do |row, index|
                    row = row.split("\t")
                    if content_check(row[1]) == 1 && row[4] == '0' && index > 0 && row[5].to_i >= 1950
                        if content == 1
                            count += 1
                            movie = ImdbImporter::Movie.new(row)
                            @movies << movie.node
                        # elsif content == 2
                        #     tv_content = TVContent.new(row)
                            puts "Created #{row[2]} as a Movie Node"
                        end
                    end
            end
            puts "Time to finish: #{Time.now - start_time}"
        end

        def (row)

        end



    end
end
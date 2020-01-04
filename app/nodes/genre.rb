class Genre < Node
    def self.create
        query_string = String.new
        genres = parse_genres
        
        genres.each_with_index do |genre, index|
            if index != genres.length - 1
                query_string += "(:Genre {name: '#{genre}'}),"
            else
                query_string += "(:Genre {name: '#{genre}'})"
            end
        end

        query_string = 'CREATE ' + query_string + ';'
        $neo4j_session.query(query_string)
    end

    private

    def self.parse_genres
        File.open('/Users/dangutt/Desktop/imdb_data/title.basics.tsv') do |file|
            final_list = []
            file.each_with_index do |row, index|
                row = row.split("\t")
                genres = row.last.split(',')
                genres.each do |genre|
                    new_genre = genre.gsub(/[^0-9a-z ]/i, '')
                    if !final_list.include?(new_genre)
                        final_list << new_genre
                    end
                end
                puts "final_list: #{final_list.length}"
                break if final_list.length == 30
            end
            puts final_list.inspect
            final_list
        end

    end
end
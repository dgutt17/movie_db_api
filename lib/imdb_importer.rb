class ImdbImporter
    attr_accessor :genres

    def initialize
        @genres = Array.new
    end

    def bulk_update
        phase_one
        phase_two
        phase_three
    end

    private

    def phase_one
        Index.create
        Year.create
        Month.create
        Day.create
        ImdbScore.create
    end

    def phase_two
        puts "Phase Two................................."
        find_genres
        Genre.create(@genres)
    end

    def phase_three
        puts "Phase Three................................."
    end

    def find_genres
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
                puts '...................'
                # break if final_list.length == 30
            end
            puts final_list.inspect
            @genres = final_list
        end
    end
    # def content_check(type)
    #     if type == 'movie'
    #         return 1
    #     elsif type == 'tvSeries' || type == 'tvMiniSeries' || type == 'tvMovie'
    #         return 2
    #     else
    #         return 0
    #     end
    # end

    # def create_indices
    #     $neo4j_session.query('CREATE INDEX ON :Month(value)')
    #     $neo4j_session.query('CREATE INDEX ON :Day(value)')
    #     $neo4j_session.query('CREATE INDEX ON :Imdb_Score(value)')
    #     $neo4j_session.query('CREATE INDEX ON :Year(value)')
    #     $neo4j_session.query('CREATE INDEX ON :Genre(name)')
    #     $neo4j_session.query('CREATE INDEX ON :Movie(imdb_id)')
    # end
end
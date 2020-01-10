class ImdbImporter

    def initialize(args)
        args.each do |importer|
            importer.new.run
        end
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
        Genre.create
        first_unwind
    end

    def phase_three
        puts "Phase Three................................."
    end

    # def create_indices
    #     $neo4j_session.query('CREATE INDEX ON :Month(value)')
    #     $neo4j_session.query('CREATE INDEX ON :Day(value)')
    #     $neo4j_session.query('CREATE INDEX ON :Imdb_Score(value)')
    #     $neo4j_session.query('CREATE INDEX ON :Year(value)')
    #     $neo4j_session.query('CREATE INDEX ON :Genre(name)')
    #     $neo4j_session.query('CREATE INDEX ON :Movie(imdb_id)')
    # end

    def first_unwind
        start_time = Time.now
        File.open('/Users/dangutt/Desktop/imdb_data/title.basics.tsv') do |file|
        end
        puts "Time to finish: #{Time.now - start_time}"
    end
end
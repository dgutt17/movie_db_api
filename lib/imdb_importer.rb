class ImdbImporter

    def initialize
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
    end

    def phase_three
        puts "Phase Three................................."
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
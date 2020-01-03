class ImdbImporter

    def self.bulk_update
        phase_one
        phase_two
        phase_three
    end

    def self.phase_one
        Index.create
        Year.create
        Month.create
        Day.create
        ImdbScore.create
    end

    def self.phase_two
        puts "Phase Two................................."
    end

    def self.phase_three
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
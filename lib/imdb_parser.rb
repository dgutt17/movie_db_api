module ImdbParser
    def content_check(type)
        if type == 'movie'
            return 1
        elsif type == 'tvSeries' || type == 'tvMiniSeries' || type == 'tvMovie'
            return 2
        else
            return 0
        end
    end

    def create_indices
        binding.pry
        session = NEO4J_DRIVER.session

        session.query('CREATE INDEX ON :Month(value)')
        session.query('CREATE INDEX ON :Day(value)')
        session.query('CREATE INDEX ON :Imdb_Score(value)')
        session.query('CREATE INDEX ON :Year(value)')
        session.query('CREATE INDEX ON :Genre(name)')
        session.query('CREATE INDEX ON :Movie(imdb_id)')
    end
end
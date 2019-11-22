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
end
class ImdbImporter

    def initialize
        # args.each do |importer|
        #     importer.new.run
        # end
    end

    def batch_create
        phase_one
        phase_two
        phase_three
    end

    private

    def phase_one
        puts "Phase One................................."
        Index.create
        Year.create
        Month.create
        Day.create
        ImdbScore.create
    end

    def phase_two
        puts "Phase Two................................."
        Genre.create
        TitleBasicsImporter.new.run
    end

    def phase_three
        puts "Phase Three................................."
    end
end
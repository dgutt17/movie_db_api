class ImdbImporter

    attr_reader :content_hash

    def initialize
        # args.each do |importer|
        #     importer.new.run
        # end
    end

    def batch_create
        import_static_nodes
        import_genres
        @content_hash = importing_ratings
        importing_content_nodes_and_relationships
        # importing_principal_nodes_and_known_for_relationships
        # importing_content_to_principal_relationships
    end

    private

    def import_static_nodes
        puts "Importing Static Nodes................................."
        import_indices
        import_years
        import_months
        import_days
        import_imdb_scores
    end

    def importing_content_nodes_and_relationships
        puts "Importing Content Nodes and their associated relationships................................."
        TitleBasicsImporter.new(content_hash).run
    end

    def importing_principal_nodes_and_known_for_relationships
        puts "Importing Principal Nodes and Known For Relationships................................."
        PrincipalsImporter.new(content_hash).run
    end
    
    def importing_content_to_principal_relationships
        puts 'Importing content to principal relationships...........................................'
        TitlePrincipalsImporter.new(content_hash).run
    end

    def importing_ratings
        puts 'Importing IMDB ratings data............................................................'
        RatingsImporter.new.run
    end

    def import_indices
        Index.create
    end

    def import_years
        Year.create
    end

    def import_months
        Month.create
    end

    def import_days
        Day.create
    end

    def import_imdb_scores
        ImdbScore.create
    end

    def import_genres
        puts 'Importing Genre Nodes....................................'
        Genre.create
    end
    
end
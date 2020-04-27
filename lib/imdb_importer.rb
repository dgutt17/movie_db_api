class ImdbImporter

    def initialize
    end

    def batch_create
        import_static_nodes
        import_genres
        create_content_hash
        # create_principals_hash
        importing_content_nodes_and_relationships
        importing_principal_nodes_and_known_for_relationship
        importing_content_to_principal_relationships
        importing_ratings
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

    def create_content_hash
        @content_hash = CreateContentHash.new.run
    end

    def create_principals_hash
        @principals_hash = CreatePrincipalsHash.new(@content_hash).run
    end

    def importing_content_nodes_and_relationships
        puts "Importing Content Nodes and their associated relationships................................."
        # @content_hash = TitleBasicsImporter.new(@ratings_hash).run
        TitleBasicsImporter.new(@content_hash).run
    end

    def importing_principal_nodes_and_known_for_relationships
        puts "Importing Principal Nodes and Known For Relationships................................."
        PrincipalsImporter.new(@content_hash).run
    end
    
    def importing_content_to_principal_relationships
        puts 'Importing content to principal relationships...........................................'
        TitlePrincipalsImporter.new(@content_hash).run
    end

    def importing_ratings
        puts 'Importing IMDB ratings data............................................................'
        RatingsImporter.new(@content_hash).run
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
class ImdbImporter

    attr_reader :content_hash, :principal_hash

    def initialize
        # args.each do |importer|
        #     importer.new.run
        # end
    end

    def batch_create
        import_static_nodes
        import_genres
        importing_content_nodes_and_relationships
        # @principal_hash = importing_content_to_principal_relationships
        # importing_principal_nodes_and_known_for_relationships
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

    def content_hash
        @content_hash ||= ContentParser.new.run
    end

    def importing_content_nodes_and_relationships
        puts "Importing Content Nodes and their associated relationships................................."
        TitleBasicsImporter.new(content_hash).run
    end

    def importing_principal_nodes_and_known_for_relationships
        puts "Importing Principal Nodes and Known For Relationships................................."
        PrincipalsImporter.new(content_hash, principal_hash).run
    end
    
    def importing_content_to_principal_relationships
        puts 'Importing content to principal relationships...........................................'
        TitlePrincipalsImporter.new(content_hash).run
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
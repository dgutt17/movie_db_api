class ImdbImporter

    def initialize
        # args.each do |importer|
        #     importer.new.run
        # end
    end

    def batch_create
        create_static_nodes
        import_genres
        importing_content_nodes_and_relationships
        importing_principal_nodes_and_known_for_relationships
        importing_principal_content_relationships
    end

    private

    def create_static_nodes
        puts "Creating Static Nodes................................."
        create_indices
        create_years
        create_months
        create_days
        create_imdb_scores
    end

    def importing_content_nodes_and_relationships
        puts "Importing Content Nodes and their associated relationships................................."
        Genre.create
        @content_hash = TitleBasicsImporter.new.run
    end

    def importing_principal_nodes_and_known_for_relationships
        puts "Importing Principal Nodes and Known For Relationships................................."
        PrincipalsImporter.new(@content_hash).run
    end
    
    def importing_content_to_principal_relationships
        puts 'Importing content to principal relationships...........................................'
        TitlePrincipalsImporter.new(@content_hash).run
    end

    def create_indices
        Index.create
    end

    def create_years
        Year.create
    end

    def create_months
        Month.create
    end

    def create_days
        Day.create
    end

    def create_imdb_scores
        ImdbScore.create
    end

    def import_genres
        puts 'Importing Genre Nodes....................................'
        Genre.create
    end
    
end
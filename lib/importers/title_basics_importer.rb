class TitleBasicsImporter
    include ImporterParsingMethods

    attr_accessor :headers, :content

    def initialize(content)
        @content = content.values
    end

    def run
        count = 0
        content.each do |row|
            if count == 50000
                count = 0
                import
            elsif can_add_data?(row)
                collect(row)
                count += 1
            end
        end

        import
    end

    private

    def batch_create_movies
      @batch_create_movies ||= BatchMerge::Nodes.new(type: :movie)
    end

    def batch_create_tv_shows
      @batch_create_tv_shows ||= BatchMerge::Nodes.new(type: :tv_show)
    end

    def batch_create_categorized_as_relationships
      @batch_create_categorized_as_relationships ||= BatchCreate::Relationships::CategorizedAs.new
    end

    def batch_create_released_relationships
        @batch_create_released_relationships ||= BatchCreate::Relationships::Released.new
    end

    def batch_create_rated_relationships
        @batch_create_released_relationships ||= BatchCreate::Relationships::Rated.new
     end

    def collect(row)
        batch_create_movies.collect(row)
        batch_create_tv_shows.collect(row)
        batch_create_categorized_as_relationships.collect(row)
        batch_create_released_relationships.collect(row)
        batch_create_rated_relationships.collect(row)
    end

    def import
        puts "unwinding.............................................."
        batch_create_movies.import
        batch_create_tv_shows.import
        batch_create_categorized_as_relationships.import
        batch_create_released_relationships.import
        batch_create_rated_relationships.import
        puts "done..................................................."
    end
end
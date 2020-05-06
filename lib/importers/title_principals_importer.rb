require 'importer_parsing_methods'
class TitlePrincipalsImporter
  include ImporterParsingMethods

  attr_accessor :headers, :count, :file_path, :content_hash

  def initialize(content_hash)
    @file_path = ENV['TITLE_PRINCIPALS_PATH']
    @content_hash = content_hash

    @batch_create_acted_in_relationships = batch_create_acted_in_relationships
    @batch_create_created_cinematography_relationships = batch_create_created_cinematography_relationships
    @batch_create_produced_relationships = batch_create_produced_relationships
    @batch_create_wrote_relationships = batch_create_wrote_relationships
    @batch_create_directed_relationships = batch_create_directed_relationships
    @batch_create_composed_relationships = batch_create_composed_relationships

    @count = 0
    @editor_count = 0
  end

  def run
    File.open(file_path) do |file|
      title_principal_parser(file)
    end
  end

  private

  def title_principal_parser(file)
    file.each_with_index do |row, index|
      if index == 0
        @headers = create_headers(row)
      elsif @count == 50000
        import
      else
        row = parse_row(row)
        next if !content_hash[row[:tconst].to_sym]
        collect(row)
        @count += 1
      end
    end

    import if count > 0
  end

  def collect(row)
    case row[:category]
    when 'actor'
      @batch_create_acted_in_relationships.collect(row)
    when 'self'
      @batch_create_acted_in_relationships.collect(row)
    when 'director'
      @batch_create_directed_relationships.collect(row)
    when 'composer'
      @batch_create_composed_relationships.collect(row)
    when 'writer'
      @batch_create_wrote_relationships.collect(row)
    when 'cinematographer'
      @batch_create_created_cinematography_relationships.collect(row)
    when 'editor'
      puts 'Editor.............................'
      @editor_count += 1
    else
      @batch_create_produced_relationships.collect(row)
    end      
  end

  def import
    @count = 0
    puts "unwinding.............................................."
    @batch_create_acted_in_relationships.import
    @batch_create_directed_relationships.import
    @batch_create_composed_relationships.import
    @batch_create_wrote_relationships.import
    @batch_create_created_cinematography_relationships.import
    @batch_create_produced_relationships.import
    puts "done..................................................."
  end

  def batch_create_acted_in_relationships
    BatchCreate::Relationships::ActedIn.new
  end

  def batch_create_created_cinematography_relationships
    BatchCreate::Relationships::CreatedCinematography.new
  end

  def batch_create_produced_relationships
    BatchCreate::Relationships::Produced.new
  end

  def batch_create_wrote_relationships
    BatchCreate::Relationships::Wrote.new
  end

  def batch_create_directed_relationships
    BatchCreate::Relationships::Directed.new
  end

  def batch_create_composed_relationships
    BatchCreate::Relationships::Composed.new
  end

  def add_to_principal_hash(cypher_object)
    parse_cypher_return_node_object(cypher_object)
  end
end
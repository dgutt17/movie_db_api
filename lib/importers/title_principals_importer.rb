require 'importer_parsing_methods'
class TitlePrincipalsImporter
  include ImporterParsingMethods

  attr_accessor :headers, :count, :file_path, :content_hash, :principal_hash

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

    @principal_hash = {}
  end

  def run
    File.open(file_path) do |file|
      title_principal_parser(file)
    end

    principal_hash
  end

  private

  def title_principal_parser(file)
    @headers = create_headers(file.first)
    file.each_with_index do |row|
      row = parse_row(row)
      if @count == 50000
        import
      elsif content_hash[row[:tconst]].present?
        next unless can_add_data?(content_hash[row[:tconst]])
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
    when 'actress'
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
    when 'producer'
      @batch_create_produced_relationships.collect(row)
    end      
  end

  def import
    @count = 0
    cypher_objects = []
    puts "unwinding.............................................."
    cypher_objects << @batch_create_acted_in_relationships.import
    cypher_objects << @batch_create_directed_relationships.import
    cypher_objects << @batch_create_composed_relationships.import
    cypher_objects << @batch_create_wrote_relationships.import
    cypher_objects << @batch_create_created_cinematography_relationships.import
    cypher_objects << @batch_create_produced_relationships.import
    add_to_principal_hash(cypher_objects)
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

  def add_to_principal_hash(cypher_objects)
    parse_cypher_return_node_object(cypher_objects, true)
  end
end
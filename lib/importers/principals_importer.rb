require 'importer_parsing_methods'
class PrincipalsImporter
  include ImporterParsingMethods

  attr_accessor :principals, :headers, :count, :file_path

  def initialize(principal_hash)
    @file_path = ENV['PRINCIPALS_PATH']
    # @content_hash = content_hash
    @principal_hash = principal_hash
    @batch_create_known_for_relationships = batch_create_known_for_relationships
    @batch_create_principals = batch_create_principals
    @count = 0
  end

  def run
    File.open(file_path) do |file|
      principle_parser(file)
    end
  end

  private

  def principle_parser(file)
    @headers = create_headers(file.first)
    file.each_with_index do |row, index|
      next if index == 0
      row = parse_row(row)
      if @count == 50000
        import
      elsif @principal_hash[row[:nconst]]
        collect(row)
        @count += 1
      end
    end

    import if count > 0
  end

  def batch_create_known_for_relationships
    BatchCreate::Relationships::KnownFors.new(@content_hash)
  end

  def batch_create_principals
    BatchCreate::Nodes::Principals.new
  end

  def collect(row)
    @batch_create_principals.collect(row)
    @batch_create_known_for_relationships.collect(row)
  end

  def import
    @count = 0
    puts "unwinding.............................................."
    @batch_create_principals.import
    @batch_create_known_for_relationships.import
    puts "done..................................................."
  end
end
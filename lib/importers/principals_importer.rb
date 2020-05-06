require 'importer_parsing_methods'
class PrincipalsImporter
  include ImporterParsingMethods

  attr_accessor :principals, :headers, :count, :file_path, :content_hash, :principal_hash

  def initialize(content_hash, principal_hash)
    @file_path = ENV['PRINCIPALS_PATH']
    @content_hash = content_hash
    @batch_create_known_for_relationships = batch_create_known_for_relationships
    @batch_update_principals = batch_update_principals
    @count = 0
    @principal_hash = principal_hash
  end

  def run
    File.open(file_path) do |file|
      principle_parser(file)
    end
  end

  private

  def principle_parser(file)
    file.each_with_index do |row, index|
      if index == 0
        @headers = create_headers(row)
      elsif @count == 50000
        import
      else
        row = parse_row(row)
        next if !principal_hash[row[:nconst].to_sym]
        collect(row)
        @count += 1
      end
    end

    import if count > 0
  end

  def batch_create_known_for_relationships
    BatchCreate::Relationships::KnownFors.new(@content_hash)
  end

  def batch_update_principals
    BatchUpdate::Nodes::Principals.new
  end

  def collect(row)
    @batch_update_principals.collect(row)
    @batch_create_known_for_relationships.collect(row)
  end

  def import
    @count = 0
    puts "unwinding.............................................."
    @batch_update_principals.import
    @batch_create_known_for_relationships.import
    puts "done..................................................."
  end
end
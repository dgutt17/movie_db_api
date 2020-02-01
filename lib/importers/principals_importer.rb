require 'query_methods'
require 'importer_parsing_methods'
class PrincipalsImporter
  include Neo4j::QueryMethods
  include ImporterParsingMethods

  attr_accessor :principals, :headers, :count, :file_path

  def initialize
    @file_path = ENV['PRINCIPALS_PATH']
    @batch_create_known_for_relationships = batch_create_known_for_relationships
    @batch_create_principals = batch_create_principals
    @count = 0
  end

  def run
    start_time = Time.now
    File.open(file_path) do |file|
      principle_parser(file)
    end
  end

  private

  def principle_parser(file)
    file.each_with_index do |row, index|
      if index == 0
        set_headers(row)
      elsif @count == 50000
        # import
      else
        row = parse_row(row)
        collect(row)
        @count += 1
      end
    end

    import if principals.count > 0
  end

  def set_headers(row)
    @headers = row.split("\t").map{|header| header.gsub("\n","").to_sym}
  end

  def parse_row(row)
    parsed_row = {}
    row = row.split("\t")
    @headers.each_with_index do |header, index|
        parsed_row[header] = row[index]
    end

    parsed_row
  end

  def batch_create_known_for_relationships
    BatchCreate::Relationships::KnownFors.new
  end

  def batch_create_principals
    BatchCreate::Nodes::Principals.new
  end

  def collect(row)
    @batch_create_known_for_relationships.collect(row)
    @batch_create_principals.collect(row)
  end

  def import
    @count = 0
    puts "unwinding.............................................."
    @batch_create_known_for_relationships.import
    @batch_create_principals.import
    puts "done..................................................."
  end
end
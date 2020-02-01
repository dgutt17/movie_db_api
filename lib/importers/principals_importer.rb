require 'query_methods'
require 'importer_parsing_methods'
class PrincipalsImporter
  include Neo4j::QueryMethods
  include ImporterParsingMethods

  attr_accessor :principals, :headers, :count, :file_path

  def initialize
    @file_path = ENV['PRINCIPALS_PATH']
    @principals = []
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
      @headers = create_headers(row) if index == 0
      row = parse_row(row)
      @principals << Principal.new(row).node
      puts "Created principle #{row[:primaryName]}"
      @count += 1
      import if @count == 50000
    end

    import if principals.count > 0
  end

  def import
    @count = 0
    puts "unwinding.............................................."
    import_principals
    @principals = []
    puts "done..................................................."
  end

  def import_principals
    $neo4j_session.query(batch_create_nodes('Principal'), list: @principals)
  end
end
require 'importer_parsing_methods'
class RatingsImporter
  include ImporterParsingMethods

  attr_accessor :principals, :headers, :count, :file_path, :content_hash

  def initialize
    @file_path = ENV['RATINGS_PATH']
    @batch_create_content = batch_create_content
    @batch_create_rated = batch_create_rated
    @count = 0
    @content_hash = {}
  end

  def run
    File.open(file_path) do |file|
      rating_parser(file)
    end

    content_hash
  end

  private

  def rating_parser(file)
    file.each_with_index do |row, index|
      if index == 0
        @headers = create_headers(row)
      elsif @count == 50000
        import
      else
        row = parse_row(row)
        next if row[:numVotes].to_i < ENV['MINIMUM_NUM_OF_VOTES'].to_i
        collect(row)
        @count += 1
      end
    end

    import if count > 0
  end

  def batch_create_rated
    BatchCreate::Relationships::Rated.new
  end

  def batch_create_content
    BatchCreate::Nodes::Content.new
  end

  def collect(row)
    @batch_create_content.collect(row)
    @batch_create_rated.collect(row)
  end

  def import
    @count = 0
    puts "unwinding.............................................."
    cypher_object = @batch_create_content.import
    @batch_create_rated.import
    add_to_content_hash(cypher_object)
    puts "done..................................................."
  end

  def add_to_content_hash(cypher_object)
    parse_cypher_return_node_object(cypher_object)
  end
end
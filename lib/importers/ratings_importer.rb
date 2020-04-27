require 'importer_parsing_methods'
class RatingsImporter
  include ImporterParsingMethods

  attr_accessor :principals, :headers, :count, :file_path

  def initialize(content_hash)
    @file_path = ENV['RATINGS_PATH']
    @content_hash = content_hash
    @batch_update_content = batch_update_content
    @batch_create_rated = batch_create_rated
    @count = 0
  end

  def run
    File.open(file_path) do |file|
      rating_parser(file)
    end
  end

  private

  def rating_parser(file)
    @headers = create_headers(file.first) 
    file.each_with_index do |row, index|
      next if index == 0
      row = parse_row(row)
      if @count == 50000
        import
      elsif content_hash[row[:tconst]]
        collect(row)
        @count += 1
      end
    end

    import if count > 0
  end

  def batch_create_rated
    BatchCreate::Relationships::Rated.new(@content_hash)
  end

  def batch_update_content
    BatchUpdate::Nodes::Content.new(@content_hash)
  end

  def collect(row)
    @batch_update_content.collect(row)
    @batch_create_rated.collect(row)
  end

  def import
    @count = 0
    puts "unwinding.............................................."
    @batch_update_content.import
    @batch_create_rated.import
    puts "done..................................................."
  end
end
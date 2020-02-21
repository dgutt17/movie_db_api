require 'importer_parsing_methods'
class RatingsImporter
  include ImporterParsingMethods

  attr_accessor :principals, :headers, :count, :file_path

  def initialize(content_hash)
    @file_path = ENV['RATINGS_PATH']
    @content_hash = content_hash
    @batch_create_known_for_relationships = batch_create_known_for_relationships
    @batch_create_principals = batch_create_principals
    @count = 0
  end

  def run
    File.open(file_path) do |file|
      rating_parser(file)
    end
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
        collect(row)
        @count += 1
      end
    end

    import if count > 0
  end

  def batch_create_known_for_relationships
    BatchCreate::Relationships::Rating.new(@content_hash)
  end

  def batch_update_movies
    BatchUpdate::Nodes::Movies.new
  end

  def batch_update_tv_shows
    BatchUpdate::Nodes::TvShows.new
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
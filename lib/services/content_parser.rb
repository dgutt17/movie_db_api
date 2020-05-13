class ContentParser
  include ImporterParsingMethods

  attr_accessor :content, :headers

  def initialize
    @content = {}
  end

  def run
    create_content_hash
    adding_ratings_and_votes_to_content

    content.values
  end

  private

  def create_content_hash
    File.open(ENV['TITLE_BASICS_PATH']) do |file|
      @headers = create_headers(file.first)
      file.each_with_index do |row, index|
        row = parse_row(row)
        if row[:titleType] == 'movie' || row[:titleType] == 'tvSeries' || row[:titleType] == 'tvMiniSeries' || row[:titleType] == 'tvMovie'
          puts "Creating Content Basic data for #{row[:primaryTitle]}"
          content[row[:tconst]] = row
        end
      end
    end
  end

  def adding_ratings_and_votes_to_content
    File.open(ENV['RATINGS_PATH']) do |file|
      @headers = create_headers(file.first)
      file.each_with_index do |row, index|
        row = parse_row(row)
        if content[row[:tconst]].present?
          puts "Adding Rating and Voting data to #{content[row[:tconst]][:primaryTitle]}"
          content[row[:tconst]].merge!(row)
        end
      end
    end
  end
end
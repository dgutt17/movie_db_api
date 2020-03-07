class CreateContentHash
  include ImporterParsingMethods

  attr_accessor :headers, :content_hash
  def initialize
    @content_hash = {}
  end

  def run
    File.open(ENV['RATINGS_PATH']) do |file|
      @headers = create_headers(file.first)

      file.each_with_index do |row, index|
        next if index == 0
        row = parse_row(row)

        @content_hash[row[:tconst]] = true if row[:numVotes].to_i >= 1000
      end
    end

    @content_hash
  end
end
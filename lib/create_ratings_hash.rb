class CreateRatingsHash
  include ImporterParsingMethods

  attr_accessor :headers, :ratings_hash
  def initialize
    @ratings_hash = {}
  end

  def run
    File.open(ENV['RATINGS_PATH']) do |file|
      @headers = create_headers(file.first)

      file.each_with_index do |row, index|
        next if index == 0
        row = parse_row(row)

        @ratings_hash[row[:tconst]] = {averageRating: row[:averageRating].to_f, numVotes: row[:numVotes].to_i} if row[:numVotes].to_i >= 1000
      end
    end

    @ratings_hash
  end
end
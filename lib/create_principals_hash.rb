class CreatePrincipalsHash
  include ImporterParsingMethods

  attr_accessor :principals_hash, :content_hash

  def initialize(content_hash)
    @principals_hash = {}
    @content_hash = content_hash
  end

  def run
    File.open(ENV['TITLE_PRINCIPALS_PATH']) do |file|
      @headers = create_headers(file.first)
      file.each_with_index do |row, index|
        next if index == 0
        row = parse_row(row)

        @principals_hash[row[:nconst]] = true if @content_hash[row[:tconst]]
      end
    end

    @principals_hash
  end

end
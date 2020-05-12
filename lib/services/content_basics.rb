class ContentBasics
  include ImporterParsingMethods

  attr_accessor :content, :headers
  attr_reader :file_path

  def initialize
    @content = {}
    @file_path = ENV['TITLE_BASICS_PATH'] 
  end

  def run
    File.open(file_path) do |file|
      @headers = create_headers(file.first)
      file.each_with_index do |row, index|
        row = parse_row(row)
        if row[:titleType] == 'movie' || row[:titleType] == 'tvSeries' || row[:titleType] == 'tvMiniSeries' || row[:titleType] == 'tvMovie'
          content[row[:tconst].to_sym] = row
        end
      end
    end
  end

  private




end
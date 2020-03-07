class CreatePrincipalsHash
  include ImporterParsingMethods

  attr_accessor :principals_hash

  def initialize
    @principals_hash = {}
  end

  def run
    File.open(ENV['PRINCIPALS_PATH']) do |file|
      @headers = create_headers(file.first)

    end
  end

end
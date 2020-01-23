require 'query_methods'
class PrincipalsImporter
  include Neo4j::QueryMethods

  attr_accessor :principals

  def initialize
    @file_path = ENV['PRINCIPALS_PATH']
    @principals = []
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
      
    end
  end


end
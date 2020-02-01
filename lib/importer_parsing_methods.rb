module ImporterParsingMethods
  def parse_row(row)
    parsed_row = {}
    row = row.split("\t")
    headers.each_with_index do |header, index|
        parsed_row[header] = row[index]
    end

    parsed_row
  end

  def create_headers(row)
    row.split("\t").map{|header| header.gsub("\n","").to_sym}
  end
end
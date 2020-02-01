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

  def parse_cypher_return_node_object(obj)
    obj.rows.each do |row|
      imdb_id = row.first.properties[:imdb_id].to_sym
      content_hash[imdb_id_key(row)] = true
    end
  end

  def imdb_id_key(row)
    row.first.properties[:imdb_id].to_sym
  end
end
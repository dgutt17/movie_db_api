class Rated < Relationship

  def relationship
    {from: args[:tconst], to: imdb_score_value, properties: {}}
  end

  private
  
  def imdb_score_value
    args[:averageRating].to_s.first.to_i
  end
end
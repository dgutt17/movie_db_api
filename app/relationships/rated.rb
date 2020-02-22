class Rated < Relationship

  private

  def set_relationship
    {from: args[:tconst], to: imdb_score_value, properties: {}}
  end

  def imdb_score_value
    args[:averageRating].to_s.first.to_i
  end
end
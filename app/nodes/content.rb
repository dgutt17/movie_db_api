class Content < Node

  def self.rating_properties(args)
    {
      id: args[:tconst],
      properties: {
        imdb_rating: args[:averageRating].to_f,
        number_of_votes: args[:numVotes].split("\n").first.to_i
      }
    }
  end
end
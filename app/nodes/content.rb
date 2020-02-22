class Content < Node

  def self.rating_properties(args)
    {
      id: args[:tconst],
      properties: {
        imdb_rating: args[:averageRating],
        number_of_votes: args[:numVotes]
      }
    }
  end
end
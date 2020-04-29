class Content < Node
  attr_reader :node
  def self.rating_properties(args)
    {
      id: args[:tconst],
      properties: {
        imdb_rating: args[:averageRating].to_f,
        number_of_votes: args[:numVotes].split("\n").first.to_i
      }
    }
  end

  def initialize(content)
    @node = {
      id: content[:tconst],
      properties: {
        imdb_id: content[:tconst],
        imdb_rating: content[:averageRating].to_f,
        number_of_votes: content[:numVotes].split("\n").first.to_i
      }
    }
  end
end
class TvShow < Node
  attr_accessor :node, :tv_show
  def initialize(tv_show)
    @tv_show = tv_show
    @node = {
      id: tv_show[:tconst],
      properties: {
        imdb_id: tv_show[:tconst], 
        title: parse_title, 
        runtime: parse_runtime,
        imdb_score: parse_score,
        num_of_votes: parse_votes
      }
    }
  end

  private

  def parse_title
    tv_show[:primaryTitle].gsub(/'/, '|')
  end

  def parse_runtime
    tv_show[:runtimeMinutes].to_i
  end

  def parse_score
    tv_show[:averageRating].to_f
  end

  def parse_votes
    tv_show[:numVotes].to_i
  end
end
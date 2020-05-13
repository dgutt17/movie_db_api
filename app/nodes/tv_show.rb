class TvShow < Node
  attr_accessor :tv_show
  def initialize(tv_show)
    @tv_show = tv_show
  end

  def node
    @node ||= {
      id: tv_show[:tconst],
      properties: {
        imdb_id: tv_show[:tconst],
        title: parse_title, 
        imdb_rating: tv_show[:averageRating].to_f,
        number_of_votes: tv_show[:numVotes].split("\n").first.to_i,
        runtime: parse_runtime
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
end
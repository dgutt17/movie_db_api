class TvShow < Node
  attr_accessor :tv_show
  def initialize(tv_show)
    @tv_show = tv_show
  end

  def node
    @node ||= {
      id: tv_show[:tconst],
      properties: {
        title: parse_title, 
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
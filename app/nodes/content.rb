class Content < Node
  attr_accessor :content
  attr_reader :type

  def initialize(content)
    @content = content
    @type = parse_type(content[:titleType])
  end
  
  def content_node
    if movie?
      {node: Movie.new(content).node, type: type}
    elsif tv_show?
      {node: TvShow.new(content).node, type: type}
    else
      {node: nil, type: type}
    end
  end

  private
  def movie?
    type == :movie
  end

  def tv_show?
    type == :tv_show
  end

  def parse_type(type)
    if type == 'movie'
      :movie
    elsif type == 'tvSeries' || type == 'tvMiniSeries' || type == 'tvMovie'
      :tv_show
    else
      :nothing
    end
  end
end
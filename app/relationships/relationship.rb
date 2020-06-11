class Relationship
  attr_reader :args

  def initialize(args)
    @args = args
  end

  def relationship
    @relationship ||= {from: args[:nconst], to: args[:tconst], properties: {}}
  end
end
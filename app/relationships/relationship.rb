class Relationship
  attr_reader :args, :relationship

  def initialize(args)
    @args = args
    @relationship = set_relationship
  end

  private

  def set_relationship
    {from: args[:nconst], to: args[:tconst], properties: {}}
  end
end
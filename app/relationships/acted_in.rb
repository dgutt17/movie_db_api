class ActedIn < Relationship
  def relationship
    @relationship ||= {from: args[:nconst], to: args[:tconst], properties: {characters: args[:characters]}}
  end
end
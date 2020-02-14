class ActedIn < Relationship

  private
  def set_relationship
    {from: args[:nconst], to: args[:tconst], properties: {characters: args[:characters]}}
  end
end
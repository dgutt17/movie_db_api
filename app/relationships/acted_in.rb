class ActedIn < Relationship
  def relationship
    @relationship ||= {from: args[:nconst], to: args[:tconst], properties: {characters: characters}}
  end

  private

  def characters
    JSON.parse(args[:characters]) unless args[:characters] == "\\N\n"
  end
end
class KnownFor < Relationship

  attr_reader :relationships

  def initalize(args)
    @args = args
    @relationships = set_relationships
  end

  private

  def set_relationships
    args[:knownForTitles].split(',').map {|movie_id| {from: args[:nconst], to: movie_id}}
  end
end
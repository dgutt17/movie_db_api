class KnownFor < Relationship

  attr_reader :relationships, :args

  def initialize(args)
    @args = args
    @relationships = set_relationships
  end

  private

  def set_relationships
    args[:knownForTitles].split(',').map {|movie_id| {from: args[:nconst], to: movie_id, properties: {}}}
  end
end
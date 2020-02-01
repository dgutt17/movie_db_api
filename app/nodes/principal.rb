class Principal < Node
  attr_accessor :node
  attr_reader :args

  def initialize(args)
    @args = args
    @node = {
      imdb_id: imdb_id, 
      first_name: first_name, 
      last_name: last_name,
      birthYear: birth_year,
      deathYear: death_year
    }
  end

  private

  def first_name
    args[:primaryName].split(" ").first
  end

  def last_name
    args[:primaryName].split(" ").last
  end

  def birth_year
    args[:birthYear]
  end

  def death_year
    args[:deathYear]
  end

  def imdb_id
    args[:nconst]
  end
end
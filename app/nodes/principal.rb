class Principal < Node

  attr_reader :node, :args

  def initialize(args)
    @args = args
    @node = {
      imdb_id: imdb_id, 
      first_name: first_name, 
      last_name: last_name,
      birth_year: birth_year,
      death_year: death_year
    }
  end

  private

  def imdb_id
    args[:nconst]
  end

  def first_name
    args[:primaryName].split(' ').first
  end

  def last_name
    args[:primaryName].split(' ').last
  end

  def birth_year
    args[:birthYear]
  end

  def death_year
    args[:deathYear]
  end
end
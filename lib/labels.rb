module Labels
  MOVIE = 'Movie'.freeze
  CATEGORIZED_AS = 'CATEGORIZED_AS'.freeze
  RELEASED = 'RELEASED'.freeze
  GENRE = 'Genre'.freeze
  YEAR = 'Year'.freeze
  TVSHOW = 'TvShow'.freeze
  PRINCIPAL = 'Principal'.freeze
  KNOWNFOR = 'KNONWN_FOR'.freeze
  ACTEDIN = 'ACTED_IN'.freeze
  WROTE = 'WROTE'.freeze
  CREATED_CINEMATOGRAPHY = 'CREATED_CINEMATOGRAPHY'.freeze
  DIRECTED = 'DIRECTED'.freeze
  PRODUCED = 'PRODUCED'.freeze
  COMPOSED = 'COMPOSED'.freeze

  def self.content_label(type)
      type == :movie ? MOVIE : TVSHOW
  end
end
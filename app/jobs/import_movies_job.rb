class ImportMoviesJob
    include Sidekiq::Worker
    sidekiq_options retry: 1

    def perform(query_str)
        # binding.pry
        $neo4j_session.query(query_str)
    end
end
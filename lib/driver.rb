require 'neo4j/core/cypher_session/adaptors/bolt'

module Neo4j
    class Driver
        def initialize
            cert_store = OpenSSL::X509::Store.new
            path_to_certificate = ENV['NEO4J_CERT_PATH']
            cert_store.add_file(path_to_certificate)
            bolt_path = 'bolt://neo4j:' + ENV['NEO4J_PASSWORD'] + '@localhost:' + ENV['NEO4J_PORT']
            @bolt_adaptor = Neo4j::Core::CypherSession::Adaptors::Bolt.new(bolt_path, timeout: 10, ssl: false)
        end

        def session
            return Neo4j::Core::CypherSession.new(@bolt_adaptor)
        end
    end
end
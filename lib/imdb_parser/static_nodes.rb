module ImdbParser
    class StaticNodes
        require 'neo4j/core/cypher_session/adaptors/bolt'
        def self.create_month_nodes
            cert_store = OpenSSL::X509::Store.new
            path_to_certificate = "/Users/dangutt/Library/Application Support/Neo4j Desktop/Application/neo4jDatabases/database-7dce9f52-ab9a-4eb7-8353-c97e702fd774/installation-3.5.12/certificates/neo4j.cert"
            cert_store.add_file(path_to_certificate)
            bolt_adaptor = Neo4j::Core::CypherSession::Adaptors::Bolt.new('bolt://neo4j:123456@localhost:7687', ssl: {cert_store: cert_store})

            neo4j_session = Neo4j::Core::CypherSession.new(bolt_adaptor)

            month = 1

            while month <= 12 do
                query_str = "CREATE (n:Month {value: #{month}});"
                neo4j_session.query(query_str)
                month += 1
            end

        end
    end
end
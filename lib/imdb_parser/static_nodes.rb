module ImdbParser
    class StaticNodes
        require 'neo4j/core/cypher_session/adaptors/bolt'
        require 'neo4j/core/cypher_session/adaptors/http'
        def self.create_month_nodes
            # http_adaptor = Neo4j::Core::CypherSession::Adaptors::HTTP.new('http://neo4j:123456@localhost:7474')
            bolt_adaptor = Neo4j::Core::CypherSession::Adaptors::Bolt.new('bolt://neo4j:12345@localhost:7687')

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
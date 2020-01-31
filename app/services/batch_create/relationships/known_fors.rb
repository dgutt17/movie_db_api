module BatchCreate
  module Relationships
    class KnownFors
      attr_reader :relationships
    
      def initalize
        @relationships = []
      end
    
      def collect(relationship)
        relationships << relationship
      end
    end
  end
end
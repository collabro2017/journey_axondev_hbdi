module Nerve
  class EventStoreClient
    class Event
      attr_reader :data, :metadata, :client
      def initialize(event_data, metadata, client)
        @data = event_data
        @metadata = metadata
        @client = client
      end

      def id
        @id ||= begin
          if metadata['entries']
            metadata['entries'].first['eventId']
          else
            SecureRandom.uuid
          end
        end
      end

      def ack!
        client.acknowledge_event(self, true)
      end

      def nack!
        client.acknowledge_event(self, false)
      end
    end
  end
end

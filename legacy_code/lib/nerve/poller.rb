module Nerve
  class Poller
    include Celluloid
    attr_reader :registry, :client

    def initialize(registry, client)
      @registry = registry
      @client = client
    end

    def poll(subscription)
      event = client.get_next_event(subscription)
      if event
        future = registry[:workers].future.work(event, subscription)
        registry[:worker_handler].register(future)
      end
    end
  end
end

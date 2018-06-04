module Nerve
  class ParkedMessagesPoller
    include Celluloid

    attr_reader :client

    def initialize(replay_interval, client)
      @client = client
      @replay_interval = replay_interval
    end

    def poll(subscription, last_run_results=nil)
      parked_message_count = client.parked_message_count(subscription)
      if (parked_message_count > 0 && ready_to_replay(last_run_results))
        client.replay_parked_messages(subscription)
        {
          parked_message_count: parked_message_count,
          last_replayed_at: Time.now
        }
      else
        last_replayed_at = last_run_results ?
                            last_run_results[:last_replayed_at] : nil
        {
          parked_message_count: parked_message_count,
          last_replayed_at: last_replayed_at
        }
      end
    end

    def ready_to_replay(last_run_results)
      last_run_results.nil? ||
        last_run_results[:last_replayed_at].nil? ||
        (last_run_results[:last_replayed_at] + @replay_interval  < Time.now)
    end
  end
end

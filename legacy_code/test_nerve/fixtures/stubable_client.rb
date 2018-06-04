class StubableClient < Nerve::EventStoreClient

  def initialize
  end

  def replay_parked_messages(subscription)

  end

  def acknowledge_event(event,succeeded,retry_event=true)
  end
end

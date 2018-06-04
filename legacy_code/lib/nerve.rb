require "celluloid/current"

module Nerve
  autoload :PollingManager, 'nerve/polling_manager'
  autoload :Subscription, 'nerve/subscription'
  autoload :Actor, 'nerve/actor'
  autoload :WorkerHandler, 'nerve/worker_handler'
  autoload :EventStoreClient, 'nerve/event_store_client'
  autoload :Listener, 'nerve/listener'
  autoload :Subscription, 'nerve/subscription'
  autoload :ParkedMessagesPoller, 'nerve/parked_messages_poller'
  autoload :Poller, 'nerve/poller'
  autoload :EventWorker, 'nerve/event_worker'

  class << self
    attr_accessor :subscription_namespace,
                  :polling_interval,
                  :cleanup_interval,
                  :parked_polling_interval,
                  :parked_replay_interval

  end
  def self.work
    @supervisor_monitor = supervisor.run!({})
    polling_manager.async.begin_polling(subscriptions, :pollers)
    parked_polling_manager.async.begin_polling(subscriptions, :parked_pollers)
    worker_handler.async.monitor_workers
  end

  def self.init(configuration)
    @configuration = configuration
    @eventstore_client = EventStoreClient.new(configuration)
  end

  def self.polling_manager
    Celluloid::Actor[:polling_manager]
  end

  def self.parked_polling_manager
    Celluloid::Actor[:parked_polling_manager]
  end

  def self.worker_handler
    Celluloid::Actor[:worker_handler]
  end

  def self.eventstore_client
    @eventstore_client
  end

  def self.stop
    polling_manager.stop
    parked_polling_manager.stop
    worker_handler.stop
    @supervisor_monitor.terminate
  end

  def self.subscriptions
    @subscriptions ||= []
  end

  def self.register_subscriptions(new_subscriptions)
    @subscriptions = subscriptions.concat(new_subscriptions)
  end

  def self.supervisor
    cleanup = cleanup_interval
    polling = polling_interval
    parked_polling = parked_polling_interval
    parked_replay = parked_replay_interval
    @supervisor ||= begin
      Class.new(Celluloid::Supervision::Container) do
        pool Nerve::Poller,  {as: :pollers, size: 5, args:[Celluloid::Actor, Nerve.eventstore_client]}
        pool Nerve::ParkedMessagesPoller,  {as: :parked_pollers, size: 5, args:[parked_replay, Nerve.eventstore_client]}
        pool Nerve::EventWorker, as: :workers, size: 5
        supervise type: Nerve::WorkerHandler, as: :worker_handler, args: [cleanup]
        supervise type: Nerve::PollingManager, as: :polling_manager, args: [polling]
        supervise type: Nerve::PollingManager, as: :parked_polling_manager, args: [parked_polling]

      end
    end
  end

  def self.reset
    @subscriptions = []
  end
end

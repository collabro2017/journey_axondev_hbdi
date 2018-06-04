module Nerve
  class PollingManager
    include Celluloid
    attr_reader :subscriptions

    def initialize(wake_interval=5, registry=Celluloid::Actor)
      @wake_interval = wake_interval
      @registry = registry
      @stopping = false
    end

    def begin_polling(subscriptions, poller_pool_name)
      enumerator = subscriptions.cycle
      loop do
        if @wake_interval
          sleep(@wake_interval)
        else
          sleep(5)
        end

        subscription = begin
                        enumerator.next
                      rescue StopIteration
                        nil
                      end

        raise "No subscriptions to work" if subscription.nil?

        poll_subscription!(subscription, poller_pool_name)

        break if @stopping
      end
    end

    def poll_subscription!(subscription, poller_pool_name)
      pool = @registry[poller_pool_name]
      unless still_polling_subscription?(subscription)
        last_run_results = subscription_status_map[subscription]
        if pool.method(:poll).arity == 2
          subscription_status_map[subscription] = pool.future.poll(subscription, last_run_results)
        else
          subscription_status_map[subscription] = pool.future.poll(subscription)
        end
      end
    end

    def stop
      @stopping = true
      # Force all remaining futures to evaluate and block until they do
      subscription_status_map.values.map(&:value)
    end

    def subscription_status_map
      @subscription_status_map ||= {}
    end

    def still_polling_subscription?(subscription)
      subscription_status_map[subscription] && !subscription_status_map[subscription].ready?
    end
  end
end

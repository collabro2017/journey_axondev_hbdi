# For each listener class, call subscribe from background.rb
module Nerve
  module Listener
    attr_reader :nerve_topics



    def subscription_name
      if Nerve.subscription_namespace
        "#{Nerve.subscription_namespace}/#{self.name}"
      else
        self.name
      end
    end

    def subscribe(options = {})
      eventstore_client = options.delete(:client) || Nerve.eventstore_client
      subscriptions = nerve_topics.map do |t|
        group_metadata = eventstore_client
                        .create_subscription_group(t, subscription_name, options)
        Subscription.new(group_metadata, self)
      end
      Nerve.register_subscriptions(subscriptions)
    end

    def topics(*list)
      @nerve_topics = list
      self.include(InstanceMethods)
    end

    module InstanceMethods
      def initialize(*args)
        @args = args
      end
    end
  end
end

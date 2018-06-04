require 'event_store_client/request_methods'

module Nerve
  class EventStoreClient
    autoload :RequestMethods, 'event_store_client/request_methods'
    autoload :Event, 'event_store_client/event'

    include RequestMethods

    attr_reader :address

    def initialize(config)
      @address = config[:address]
      @user = config[:user]
      @password = config[:password]
    end

    def acknowledge_event(event,succeeded,retry_event=true)
      if succeeded
        link = event.metadata['links'].find{|l| l['relation'] == 'ackAll'}['uri']
        options = { }
      else
        link = event.metadata['links'].find{|l| l['relation'] == 'nackAll'}['uri']
        options = retry_event ? { action: 'retry', } : {action: 'park'}
      end
      response = acknowledge_event_request(link, options)
      if response.status != 202
        raise "Did not successfully acknowledge_event: Server returned #{response.to_s}"
      end
      nil
    end

    def create_subscription_group(stream, subscription, options={})
      response = create_subscription_request(stream, subscription, options)
      subscription_created = response.status == 201
      subscription_exists = response.status == 409 &&
        JSON.parse(response.body.to_s)["result"] == 'AlreadyExists'

      raise "Error creating subscription for #{stream}" unless subscription_created || subscription_exists
      {
        location: response.headers['Location'],
        new: response.status == 201,
        group_name: subscription,
        stream: stream
      }
    end

    def get_next_event(subscription)
      response = read_subscription_request(subscription.stream, subscription.group_name)
      data =  begin
                JSON.parse(response.body.to_s)
              rescue JSON::ParserError
                nil
              end

      entry = data['entries'].first

      if entry
        event_data = JSON.parse(entry['data'])
        Event.new(event_data, data, self)
      end
    end

    def parked_message_count(subscription)
      response = parked_message_count_request(subscription.stream, subscription.group_name)
      # Eventstore returns a 404 if there are no parked messages
      if response.status == 404
        0
      else
        JSON.parse(response.body.to_s)['entries'].count
      end
    end

    def replay_parked_messages(subscription)
      response = replay_parked_messages_request(subscription.stream, subscription.group_name)
      if response.status != 200
        raise "Did not successfully replay messages: Server returned #{response.to_s}"
      end
    end
  end
end

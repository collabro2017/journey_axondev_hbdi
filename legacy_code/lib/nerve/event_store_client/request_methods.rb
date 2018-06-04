module Nerve
  class EventStoreClient

    # Internal methods that make the direct http calls. Should be treated as
    # private to the EventStoreClient
    module RequestMethods

      def create_subscription_request(stream, subscription_name, options={})
        HTTP.basic_auth(user: @user, pass: @password)
          .put("#{address}/subscriptions/#{stream}/#{subscription_name}",
            json: {
              startFrom: -1
            }.merge(options)
          )
      end

      def delete_subscription_request(stream, subscription_name, options=nil)
        HTTP.basic_auth(user: @user, pass: @password)
          .delete("#{address}/subscriptions/#{stream}/#{subscription_name}")
      end

      def read_subscription_request(stream, subscription_name, options=nil)
        response = HTTP.headers("Accept" => "application/vnd.eventstore.competingatom+json")
                       .get("#{address}/subscriptions/#{stream}/#{subscription_name}", params:{ embed: 'body'})
        response
      end

      def subscription_info_request(stream, subscription_name)
        response = HTTP.get("#{address}/subscriptions/#{stream}/#{subscription_name}/info")
        response
      end

      def acknowledge_event_request(ack_link, options)
        HTTP.post(ack_link, params: options)
      end

      def parked_message_count_request(stream, subscription_name)
        response = HTTP.get("#{address}/subscriptions/#{stream}/#{subscription_name}/info")
        parked = JSON.parse(response.body.to_s)['parkedMessageUri']
        response = HTTP.basic_auth(user: @user, pass: @password)
                       .headers("Accept" => "application/vnd.eventstore.events+json")
                       .get(parked)
      end

      def replay_parked_messages_request(stream, subscription_name)
        response = HTTP.basic_auth(user: @user, pass: @password)
                       .post("#{address}/subscriptions/#{stream}/#{subscription_name}/replayParked")
        response
      end


      def post_to_stream_request(stream, data)
        HTTP
          .headers("Content-Type" => "application/vnd.eventstore.events+json")
          .post("#{address}/streams/#{stream}", json: prepare_event(data))
      end

      def delete_stream_request(stream)
        HTTP
          .headers("Content-Type" => "application/vnd.eventstore.events+json")
          .delete("#{address}/streams/#{stream}")
      end

      private

      def prepare_event(event)
        [
          {
          eventId: event[:event_id],
          eventType: event[:topic],
          data: event.except(:event_id)
          }
        ]
      end
    end
  end
end

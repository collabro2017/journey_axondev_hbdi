require 'test_helper'
require 'fixtures/streams'
require 'fixtures/no_op_handler'

class EventStoreClientTest < NerveTest
  extend Streams

  setup_client
  add_stream_fixture_helpers

  before { setup_stream_fixtures }
  after { teardown_stream_fixtures }

  describe "EventStoreClient" do

    describe ".create_subscription_group" do
      let(:stream){ "foo" }
      let(:subscription) { "foo_subscription"}
      let(:result){client.create_subscription_group(stream, subscription)}

      after { client.delete_subscription_request("foo", "foo_subscription") }

      it "returns the subscription meta data" do
        result[:location].must_equal "http://localhost:2113/subscriptions/#{stream}/#{subscription}"
        result[:new].must_equal true
      end

      describe "when the subscription already exists" do

        it "returns the subscription meta data with new false" do
          client.create_subscription_request("foo", "foo_subscription")
          result[:location].must_equal "http://localhost:2113/subscriptions/#{stream}/#{subscription}"
          result[:new].must_equal false
        end
      end
    end

    describe ".get_next_event" do
      let(:stream){ "foo" }
      let(:subscription_name) { "foo_subscription"}
      let(:create_group!){client.create_subscription_group(stream, subscription_name)}
      let(:subscription){ Nerve::Subscription.new(create_group!, NoOpHandler) }
      let(:result) { client.get_next_event(subscription)}

      before do
        create_group!

        client.post_to_stream_request('foo',{
          event_id: SecureRandom.uuid,
          topic: "test",
          foo: 'bar'
        })
      end
      after { client.delete_subscription_request("foo", "foo_subscription") }

      it "reads the event and returns it's data" do
        result.kind_of? Nerve::EventStoreClient::Event
        result.data['foo'].must_equal 'bar'
        result.metadata.wont_be_nil
      end
    end

    describe ".acknowledge_event" do
      let(:stream){ "foo" }
      let(:subscription_name) { "foo_subscription"}
      let(:create_group!){client.create_subscription_group(stream, subscription_name)}
      let(:subscription){ Nerve::Subscription.new(create_group!, NoOpHandler) }
      let(:event) { client.get_next_event(subscription)}

      before do
        create_group!

        client.post_to_stream_request('foo',{
          event_id: SecureRandom.uuid,
          topic: "test",
          foo: 'bar'
        })
      end
      after { client.delete_subscription_request("foo", "foo_subscription") }

      it "successfully acknowledges the event on the event store side" do
        client.acknowledge_event(event, true)
        # sleep for event store to register the data
        sleep(1)
        response = client.subscription_info_request(stream, subscription_name)
        event_number = event.metadata['entries'].first['eventNumber']
        JSON.parse(response.body.to_s)['lastProcessedEventNumber'].must_equal event_number
      end

      it "successfully nacks the event for retry on the eventstore side" do
        client.acknowledge_event(event, false)
        # sleep for event store to register the data
        sleep(1)
        event_retry = client.get_next_event(subscription)
        event_retry.wont_be_nil

        event_number = event.metadata['entries'].first['eventNumber']
        event_retry.metadata['entries'].first['eventNumber'].must_equal event_number
      end

      it "successfully nacks the event for parking on the eventstore side so it's not retried" do
        client.acknowledge_event(event, false, false)
        # sleep for event store to register the data
        sleep(1)
        event_retry = client.get_next_event(subscription)
        event_retry.must_be_nil
      end
    end

    describe ".parked_message_count" do
      let(:stream){ "foo" }
      let(:subscription_name) { "foo_subscription"}
      let(:create_group!){client.create_subscription_group(stream, subscription_name)}
      let(:subscription){ Nerve::Subscription.new(create_group!, NoOpHandler) }
      let(:event) { client.get_next_event(subscription)}
      let(:result) {client.parked_message_count(subscription)}

      describe "when there is an parked message" do
        before do
          create_group!

          client.post_to_stream_request('foo',{
            event_id: SecureRandom.uuid,
            topic: "test",
            foo: 'bar'
          })
          client.acknowledge_event(event, false, false)
          # sleep for event store to register the data
          sleep(1)
        end
        after { client.delete_subscription_request("foo", "foo_subscription") }

        it "sees one parked message" do
          result.must_equal 1
        end
      end

      describe "where there are no parked messages" do
        it "sees 0 parked messages" do
          result.must_equal 0
        end
      end
    end

    describe ".replay_parked_messages" do
      let(:stream){ "foo" }
      let(:subscription_name) { "foo_subscription"}
      let(:create_group!){client.create_subscription_group(stream, subscription_name)}
      let(:subscription){ Nerve::Subscription.new(create_group!, NoOpHandler) }
      let(:event) { client.get_next_event(subscription)}
      let(:result) {client.parked_message_count(subscription)}

      before do
        create_group!

        client.post_to_stream_request('foo',{
          event_id: SecureRandom.uuid,
          topic: "test",
          foo: 'bar'
        })
        client.acknowledge_event(event, false, false)
        # sleep for event store to register the data
        sleep(1)
      end
      after { client.delete_subscription_request("foo", "foo_subscription") }

      it "replays the message" do
        client.replay_parked_messages(subscription)
        sleep(1)
        event = client.get_next_event(subscription)
        event.wont_be_nil
      end
    end
  end


  describe "EventStoreClient::RequestMethods" do
    describe ".create_subscription_request" do
      after { client.delete_subscription_request("foo", "foo_subscription") }

      it "creates the subscription" do
        response = client.create_subscription_request("foo", "foo_subscription")
        response.status.must_equal 201
      end
    end

    describe ".read_subscription_request" do

      before do
        response = client.create_subscription_request("foo", "foo_subscription")

        client.post_to_stream_request('foo',{
          event_id: SecureRandom.uuid,
          topic: "test",
          foo: 'bar'
        })
      end

      after { client.delete_subscription_request("foo", "foo_subscription") }

      let(:result) {client.read_subscription_request("foo", "foo_subscription")}

      it "returns the event data" do
        result.status.must_equal 200
        data = JSON.parse(result.body.to_s)
        data["entries"].count.must_equal 1
      end
    end
  end
end

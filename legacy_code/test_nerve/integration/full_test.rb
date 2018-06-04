require 'test_helper'


class FullTest < NerveTest

  describe "Nerve.work" do
    let(:configuration) do
      {
        address: "http://localhost:2113",
        user: "admin",
        password: "changeit"
      }
    end

    describe "when events are posted after work starts" do
      after do
        Nerve.eventstore_client.delete_subscription_request("foo", "FullTest::TestListener")
        Nerve.eventstore_client.delete_subscription_request("bar", "FullTest::TestListener")
      end

      it "works a subscribed job" do

        TestListener = Class.new do
          extend Nerve::Listener

          topics :foo, :bar

          def run(*event)
            sleep(0.5)
            event
          end
        end

        Nerve.init(configuration)

        TestListener.subscribe
        Nerve.polling_interval=0.1
        Nerve.cleanup_interval=0.1
        Nerve.parked_polling_interval=5

        Nerve.work

        sleep(5)

        Nerve.eventstore_client.post_to_stream_request('foo',{
          event_id: SecureRandom.uuid,
          topic: "test",
          foo: 'bar'
        })

        Nerve.eventstore_client.post_to_stream_request('bar',{
          event_id: SecureRandom.uuid,
          topic: "test",
          bar: 'foo'
        })

        sleep(1)
        Nerve.stop
        Nerve.reset

        # Figure out how to debug and make sure 2 items have been processed
        response = Nerve.eventstore_client.subscription_info_request("foo", 'FullTest::TestListener')
        JSON.parse(response.body.to_s)["totalItemsProcessed"].must_equal 1

        response = Nerve.eventstore_client.subscription_info_request("bar", 'FullTest::TestListener')
        JSON.parse(response.body.to_s)["totalItemsProcessed"].must_equal 1
      end
    end

    describe "when events are posted before work starts" do
      after do
        Nerve.eventstore_client.delete_subscription_request("foo", "FullTest::DelayedStartListener")
        Nerve.eventstore_client.delete_subscription_request("bar", "FullTest::DelayedStartListener")
      end

      it "works a subscribed job " do
        DelayedStartListener = Class.new do
          extend Nerve::Listener

          topics :foo, :bar

          def run(*event)
            sleep(0.5)
            event
          end
        end

        Nerve.init(configuration)

        DelayedStartListener.subscribe
        Nerve.polling_interval=0.1
        Nerve.cleanup_interval=0.1
        Nerve.parked_polling_interval=5

        # Sleep to make sure the subscription gets created on the event store
        sleep(1)

        Nerve.eventstore_client.post_to_stream_request('foo',{
          event_id: SecureRandom.uuid,
          topic: "test",
          foo: 'bar'
        })

        Nerve.eventstore_client.post_to_stream_request('bar',{
          event_id: SecureRandom.uuid,
          topic: "test",
          bar: 'foo'
        })

        Nerve.work

        sleep(3)
        Nerve.stop
        Nerve.reset

        # Figure out how to debug and make sure 2 items have been processed
        response = Nerve.eventstore_client.subscription_info_request("foo", 'FullTest::DelayedStartListener')
        JSON.parse(response.body.to_s)["totalItemsProcessed"].must_equal 1

        response = Nerve.eventstore_client.subscription_info_request("bar", 'FullTest::DelayedStartListener')
        JSON.parse(response.body.to_s)["totalItemsProcessed"].must_equal 1
      end
    end

    describe "when a job errors out" do
      after do
        Nerve.eventstore_client.delete_subscription_request("foo", "FullTest::ErrorListener")
        Nerve.eventstore_client.delete_subscription_request("bar", "FullTest::ErrorListener")
        Celluloid.logger = Logger.new(STDERR)
      end

      it "it is retried and successfully worked the second time" do
        Celluloid.logger = nil
        ErrorListener = Class.new do
          extend Nerve::Listener

          @@count = 0

          topics :foo, :bar

          def run(*event)
            sleep(0.1)
            if @@count==0
              @@count += 1
              raise "Errors the first time"
            end
            event
          end
        end

        Nerve.polling_interval=0.1
        Nerve.cleanup_interval=0.1
        Nerve.parked_polling_interval=5
        Nerve.init(configuration)

        ErrorListener.subscribe


        # Sleep to make sure the subscription gets created on the event store
        sleep(1)

        first_uuid = SecureRandom.uuid
        Nerve.eventstore_client.post_to_stream_request('foo',{
          event_id: first_uuid,
          topic: "test",
          foo: 'bar'
        })

        Nerve.work

        sleep(3)

        Nerve.stop
        Nerve.reset

        response = Nerve.eventstore_client.subscription_info_request("foo", 'FullTest::ErrorListener')
        # totalItemsProcessed is two because one event is processed twice because of retry on error
        JSON.parse(response.body.to_s)["totalItemsProcessed"].must_equal 2
      end


      describe "when a job errors out enough to get parked" do
        after do
          Nerve.eventstore_client.delete_subscription_request("foo", "FullTest::ParkedListener")
          Nerve.eventstore_client.delete_subscription_request("bar", "FullTest::ParkedListener")
          Nerve.reset
          Celluloid.logger = Logger.new(STDERR)
        end

        it "it is parked until parked messages are replayed" do
          Celluloid.logger = nil
          ParkedListener = Class.new do
            extend Nerve::Listener

            @@count = 0

            topics :foo, :bar

            def run(*event)
              sleep(0.1)
              if @@count < 2
                @@count += 1
                raise "Erroring until parked: #{@@count}"
              end
              event
            end
          end

          Nerve.init(configuration)

          ParkedListener.subscribe(maxRetryCount: 1)
          Nerve.polling_interval=0.1
          Nerve.cleanup_interval=0.1
          Nerve.parked_polling_interval=5

          # Sleep to make sure the subscription gets created on the event store
          sleep(1)

          first_uuid = SecureRandom.uuid
          Nerve.eventstore_client.post_to_stream_request('foo',{
            event_id: first_uuid,
            topic: "test",
            foo: 'bar'
          })

          Nerve.work

          sleep(3)
          Nerve.eventstore_client.parked_message_count(Nerve.subscriptions.first).must_equal 1

          sleep(5)
          Nerve.stop

          Nerve.eventstore_client.parked_message_count(Nerve.subscriptions.first).must_equal 0

        end
      end
    end
  end
end

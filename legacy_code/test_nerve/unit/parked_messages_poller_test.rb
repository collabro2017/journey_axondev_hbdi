require 'test_helper'
require 'fixtures/stubable_client'

class ParkedMessagesPollerTest < NerveTest
  let(:client) { StubableClient.new }
  let(:parked_messages_poller){ Nerve::ParkedMessagesPoller.new(1.hour, client) }

  describe ".poll" do
    let(:subscription_params) do
      {
        group_name: 'foo_subscription',
        stream: 'foo'
      }
    end

    let(:subscription){ Nerve::Subscription.new(subscription_params, NoOpHandler)}
    let(:result){ parked_messages_poller.poll(subscription) }

    describe "when there are no parked messages" do

      it "returns the proper hash" do
        client.stub(:parked_message_count, 0) do
          result[:parked_message_count].must_equal 0
        end
      end

    end

    describe "when there are parked messages" do

      it "returns the proper hash" do
        client.stub(:parked_message_count, 1) do
          result[:parked_message_count].must_equal 1
          result[:last_replayed_at].wont_be_nil
        end
      end

    end

    describe "when the messages were just recently replayed" do
      let(:last_run_results) do
        {
          last_replayed_at: Time.now - 5.minutes,
          parked_message_count: 3
        }
      end
      let(:result){ parked_messages_poller.poll(subscription, last_run_results) }

      it "returns the proper hash" do
        client.stub(:parked_message_count, 1) do
          result[:parked_message_count].must_equal 1
          result[:last_replayed_at].must_equal last_run_results[:last_replayed_at]
        end
      end

    end
  end
end

require 'test_helper'
require 'fixtures/sample_listener'
require 'fixtures/stubable_client'
require 'fixtures/supervisor_helpers'

class PollerTest < NerveTest
  extend SupervisorHelpers

  setup_supervisor do
    pool MockWorker, as: :workers, size: 5
    supervise type: Nerve::WorkerHandler, as: :worker_handler
  end

  let(:client){ StubableClient.new }
  let(:poller){ Nerve::Poller.new(Celluloid::Actor, client) }

  describe ".poll" do
    let(:subscription){ Nerve::Subscription.new({}, SampleListener) }
    let(:result){poller.poll(subscription)}

    it "returns a future and adds to worker handler" do
      event = Nerve::EventStoreClient::Event.new({},{},client)

      client.stub :get_next_event, event do
        result.kind_of? Celluloid::Future
        Celluloid::Actor[:worker_handler].registered_workers.count.must_equal 1
      end
    end

    describe "when there is no event" do
      it "returns nil" do
        client.stub :get_next_event, nil do
          result.must_be_nil
        end
      end
    end
  end
end

require 'test_helper'
require 'fixtures/stubable_client'
require 'fixtures/sample_listener'
require 'fixtures/record_model'

ActiveRecord::Base.establish_connection(NERVE_URL)

class EventWorkerTest < NerveTest
  let(:event) { Nerve::EventStoreClient::Event.new({}, {}, StubableClient.new)}
  let(:handler) { SampleListener }
  let(:subscription) { Nerve::Subscription.new({}, handler) }
  let(:worker){ Nerve::EventWorker.new }

  describe ".work" do
    let(:result){ worker.work(event, subscription) }

    it "returns an event succeeded hash" do
      result[:status].must_equal :succeeded
    end

    describe "when the listener executes some queries against the database" do
      let(:handler) do
        Class.new do
          extend Nerve::Listener

          topics :foo, :bar

          def run
            RecordModel.connection.execute("SELECT 1")
          end
        end
      end

      it "closes the connection when it's done" do
        result
        RecordModel.connection_handler.active_connections?.must_equal false
      end
    end

    describe "when the listener executes some queries against a seperate AR model" do
      class SecondDatabaseModel < ActiveRecord::Base
        establish_connection(NERVE_URL)
      end

      SecondDatabaseModel.clear_active_connections!

      let(:handler) do
        Class.new do
          extend Nerve::Listener

          topics :foo, :bar

          def run
            SecondDatabaseModel.connection.execute("SELECT 1")
          end
        end
      end

      it "closes the connection when it's done" do
        result
        SecondDatabaseModel.connection_handler.active_connections?.must_equal false
      end
    end
  end
end

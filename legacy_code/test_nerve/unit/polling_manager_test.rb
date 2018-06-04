require 'test_helper'
require 'fixtures/no_op_handler'

class PollingManagerTest < NerveTest
  let(:subscriptions) do
    [Nerve::Subscription.new({}, NoOpHandler)]
  end
  let(:supervisor) do
    subs = subscriptions
    p_args = poller_args
    create_supervisor do
      pool MockPoller, p_args
      pool MockWorker, as: :workers, size: 5
      supervise type: Nerve::WorkerHandler, as: :worker_handler
      supervise type: Nerve::PollingManager, as: :polling_manager, args: [0.1]
    end
  end
  let(:process){ supervisor.run!({}) }

  before { process }
  after {process.terminate}

  let(:manager){ Celluloid::Actor[:polling_manager] }
  let(:poller_args){ {as: :pollers, size: 5, args:[0.1]} }

  describe "async.begin_polling" do

    it "runs asynchronously and doesn't block" do
      manager.async.begin_polling(subscriptions, :pollers)
      true.must_equal true
      manager.stop
    end
  end

  describe ".poll_subscription!" do
    describe "with a handler that takes some time to complete" do
      let(:subscription) { Nerve::Subscription.new({}, NoOpHandler) }

      it "`.stop` blocks until the worker is finished" do
        supervisor.run!
        manager.poll_subscription!(subscription, :pollers)
        manager.stop
        manager.subscription_status_map.values.all?(&:ready?).must_equal true
      end
    end

    describe "if it tries to work a subscription a second time while the first is finishing" do
      let(:subscription) { Nerve::Subscription.new({}, NoOpHandler) }

      it "skips working the second time around" do
        supervisor.run!
        manager.poll_subscription!(subscription, :pollers)
        manager.poll_subscription!(subscription, :pollers).must_be_nil
        manager.stop
      end
    end

    describe "if it tries to work a subscription again after it fails the first time" do
      # disable logging so our failed job doesn't clutter up stdout
      disable_celluiod_logging

      let(:status) { {count: 0} }
      let(:failure_block) do
        status_var = status
        -> do
          if status_var[:count] == 0
            status_var[:count] = 1
            raise "Job errored!"
          else
            status_var[:count] += 1
          end
        end
      end

      let(:poller_args){ {as: :pollers, size: 5, args:[0.1, failure_block]} }

      let(:subscription) { Nerve::Subscription.new({}, NoOpHandler) }

      it "successfully works the subscription the second time" do
        supervisor.run!
        manager.poll_subscription!(subscription,:pollers)
        sleep(0.2)
        manager.poll_subscription!(subscription, :pollers)
        manager.stop
        status[:count].must_equal 2
      end
    end
  end
end

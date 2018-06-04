require 'test_helper'

class WorkerHandlerTest < NerveTest
  let(:worker_handler) {Nerve::WorkerHandler.new(0.1)}

  describe ".register" do
    let(:future) { Celluloid::Future.new { sleep(0.1); true } }

    before{worker_handler.register(future)}

    it "has adds it to the registered_workers" do
      worker_handler.registered_workers.count.must_equal 1
    end
  end

  describe ".monitor_workers" do

    before { worker_handler.async.monitor_workers }
    after { worker_handler.stop }

    it "runs in the background removing futures as they finish" do
      worker_handler.register( Celluloid::Future.new { sleep(0.2); true } )
      worker_handler.registered_workers.count.must_equal 1
      sleep(0.5)
      worker_handler.registered_workers.count.must_equal 0
    end

  end

  describe ".stop" do
    before { worker_handler.async.monitor_workers }

    it "waits for all the futures to finish before continuing" do
      future = Celluloid::Future.new { sleep(0.5); true }
      worker_handler.register(future)
      worker_handler.stop
      future.ready?.must_equal true
    end
  end

end

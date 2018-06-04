module Nerve
  class WorkerHandler
    include Celluloid

    def initialize(wake_interval=10)
      @wake_interval = wake_interval
      @registered_workers = []
      @stopping = false
    end

    def registered_workers
      @registered_workers
    end

    def register(future)
      @registered_workers << future
    end

    def monitor_workers
      loop do
        if @wake_interval
          sleep(@wake_interval)
        else
          sleep(10)
        end

        @registered_workers = @registered_workers.reject{|w| w.ready?}
        break if @stopping
      end
    end

    def stop
      @stopping = true
      @registered_workers.map{|future| future.value rescue nil  }
    end
  end
end

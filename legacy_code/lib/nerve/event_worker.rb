module Nerve
  class EventWorker
    include Celluloid

    def work(event, subscription)
      if subscription.uses_active_record && defined?(ActiveRecord)
        ::ActiveRecord::Base.connection_pool.with_connection { work_event(event, subscription) }
      else
        work_event(event, subscription)
      end
    end

    private

    def work_event(event, subscription)
      begin
        subscription.handle(event.data)
        event.ack!
        {id: event.id, status: :succeeded}
      rescue => error
        event.nack!
        raise error
      ensure
        # # Need this for reasons outlined here https://github.com/chanks/que/pull/116
        # if defined?(ActiveRecord)
        #   ::ActiveRecord::Base.clear_active_connections!
        # end
      end
    end
  end
end

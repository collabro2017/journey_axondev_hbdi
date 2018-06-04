module Nerve
  class Subscription
    attr_reader :stream
    attr_reader :group_name
    attr_reader :uses_active_record

    def initialize(group_metadata, handler, options={})
      @stream = group_metadata[:stream]
      @group_name = group_metadata[:group_name]
      @uses_active_record = options[:uses_active_record] || true
      @handler = handler
    end

    def handle(event)
      @handler.new(*event).run(*event)
    end
  end
end

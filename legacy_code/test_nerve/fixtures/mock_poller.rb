class MockPoller
  include Celluloid

  def initialize(delay=0, custom_block=nil)
    @delay = delay
    @custom_block = custom_block
  end

  def poll(subscription)
    sleep(@delay)
    if(@custom_block)
      @custom_block.call
    end
  end
end

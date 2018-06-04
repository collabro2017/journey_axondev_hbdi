class ThinkerUpdated
  extend Nerve::Listener

  subscribes_to :thinker_updated

  def run(event)
    #handles event
    succeeded!
  end
end

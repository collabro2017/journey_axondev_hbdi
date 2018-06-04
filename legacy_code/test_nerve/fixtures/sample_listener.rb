class SampleListener
  extend Nerve::Listener

  topics :foo, :bar

  def run(*args)
  end
end

module SupervisorHelpers

  def setup_supervisor(&block)
    let(:supervisor) do
      create_supervisor &block
    end
    let(:process){ supervisor.run!({}) }

    before { process }
    after {process.terminate}
  end
end

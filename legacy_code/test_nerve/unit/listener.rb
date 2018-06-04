require 'test_helper'
require 'fixtures/SampleListener'

class ListenerTest < NerveTest
  let(:listener){ SampleListener }

  describe ".subscribe" do
    let(:result){listener.subscribe}

    it "adds subscription objects to Nerve.subscriptions" do
      Nerve.subscriptions.count.must_equal 2
    end
  end
end

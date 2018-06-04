require 'test_helper'

class ConnectionTest < ActiveSupport::TestCase

  describe ".filtered_for_user" do
    let(:user){ thinkers("models/connections/filtered_for_user/ned_herrmann") }
    let(:result){ Connection.filtered_for_user(user) }

    it "returns all the connections tied to that user" do
      result.count.must_equal 2
    end
  end
end

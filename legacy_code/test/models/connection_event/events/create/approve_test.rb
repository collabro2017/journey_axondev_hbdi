require 'test_helper'

class ConnectionEventEventsCreateApproveTest < ActiveSupport::TestCase
  let(:connection) { connections('models/connection_events/events/create/pending_connection') }
  let(:initiated_by) {thinkers('models/connection_events/events/create/john_doe')}
  let(:params) { {connection: connection, initiated_by: initiated_by} }
  let(:event){ ConnectionEvent::Events::Create::Approve.new(params) }

  describe ".handle" do
    let(:result){event.handle}

    it "returns a connection event for the result" do
      result[:result].must_be_kind_of ConnectionEvent
      result[:result].connection.must_equal connection
      result[:result].connection.status.must_equal 'approved'
    end
  end

  describe ".validate" do
    let(:result) { event.validate }

    it "has no errors and is marked as authorized" do
      result.errors.count.must_equal 0
      result.authorized?.must_equal true
    end

    describe "when performed by someone who isn't the target of the connection" do
      let(:initiated_by) {thinkers('models/connection_events/events/create/ned_herrmann')}

      it "has one errors and is not marked as authorized" do
        result.errors.count.must_equal 1
        result.authorized?.must_equal false
      end
    end

    describe "with an already approved connection" do
      let(:connection){connections('models/connection_events/events/create/approved')}

      it "has one error" do
        result.errors.count.must_equal 1
      end
    end
  end
end

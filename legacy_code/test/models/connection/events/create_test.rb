require 'test_helper'

class ConnectionEventsCreateTest < ActiveSupport::TestCase
  let(:user){ thinkers('models/connection/events/create/ned_herrmann') }
  let(:invited_email_address) { 'sue.blue@hbdi.com' }
  let(:params) do
    {
      invited_email_address: invited_email_address,
      initiating_user: user
    }
  end
  let(:event){ Connection::Events::Create.new(params) }

  describe '.validate' do
    let(:result) { event.validate }

    it 'returns no validation errors' do
      result.errors.count.must_equal 0
    end

    describe 'when the email is missing' do
      let(:params) { { } }

      it 'returns a validation object with errors' do
        result.errors.count.must_equal 1
      end
    end
  end

  describe '.handle' do
    let(:result){event.handle}

    describe 'for an email address where the thinker already exists in connect' do
      let(:invited_email_address) do
        thinkers('models/connection/events/create/susie_q').email
      end

      it 'creates a new connection with two members and publishes an event' do
        connection = result[:result]
        connection.must_be_kind_of Connection
        connection.connection_members.count.must_equal 2
        result[:effects][:events].count.must_equal 1
        event = result[:effects][:events].first
        event[1][:target][:known_thinker].must_equal true
        event[1][:target][:id].wont_be_nil
      end
    end

    describe 'for an email address where thinker does not exist in connect' do
      let(:invited_email_address) { 'email_not_existing@example.com' }

      it 'creates a new connection with 1 members and publishes an event' do
        connection = result[:result]
        connection.must_be_kind_of Connection
        connection.connection_members.count.must_equal 1
        result[:effects][:events].count.must_equal 1
        event = result[:effects][:events].first
        event[1][:target][:known_thinker].must_equal false
        event[1][:target][:id].must_be_nil
      end
    end
  end

end

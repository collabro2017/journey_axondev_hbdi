require 'application_system_test_case'

class ConnectionsEventsControllerTest < ApplicationSystemTestCase
  let(:base_params) do
    {
      headers: {'X-User-Id' => user.uuid}
    }
  end
  let(:params) { base_params }
  let(:user){thinkers('controllers/connections/ned_herrmann')}
  let(:connection){ connections('controllers/connections/visible_connection') }

  describe '.index' do
    before { get connection_connection_events_url(connection), params }

    it 'returns successfully' do
      assert_response :success
      body = JSON.parse(response.body)
      body['data'].count.must_equal 1
    end

    describe "for a connection the user can't see" do
      let(:connection){ connections('controllers/connections/not_visible_connection') }

      it "returns a 404" do
        assert_response 404
      end
    end
  end

  describe '.show' do
    let(:event){connection.connection_events.first}
    before { get connection_connection_event_url(connection, event), params }

    it 'returns successfully' do
      assert_response :success
      body = JSON.parse(response.body)
      body['data']['attributes'].keys.to_set.must_equal ['event','created-at'].to_set
    end
  end

  describe ".create" do
  end
end

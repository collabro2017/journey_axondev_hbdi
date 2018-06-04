require 'application_system_test_case'

class ConnectionsControllerTest < ApplicationSystemTestCase
  let(:base_params) do
    {
      headers: {'X-User-Id' => user.uuid}
    }
  end
  let(:params) { base_params }
  let(:user){thinkers('controllers/connections/ned_herrmann')}

  describe '.index' do
    before { get connections_url, params }

    it 'returns successfully' do
      assert_response :success
    end
  end

  describe '.show' do
    let(:connection){ connections('controllers/connections/visible_connection') }
    before { get connection_url(connection), params }

    it 'returns successfully' do
      assert_response :success
    end

    describe "with a connection the user can't see" do
      let(:connection){ connections('controllers/connections/not_visible_connection') }

      it 'returns a 404' do
        assert_response 404
      end
    end
  end

  describe '.create' do
    let(:params) do
      base_params.merge(params: {
                          "data": {
                            "type": "connection",
                            "attributes": {
                              'invited-email-address' => "sue.blue@hbdi.com"
                            },
                          }
                        })

    end
    before {post connections_url, params}

    it "returns a jsonapi response" do
      response.headers["Location"].wont_be_nil
      assert_response 201
      body = JSON.parse(response.body)
      body["data"]["attributes"]["status"].must_equal "pending"
      body["data"]["attributes"]["invited-email-address"].must_equal 'sue.blue@hbdi.com'
    end
  end
end

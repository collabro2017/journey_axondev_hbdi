module Streams

  def add_stream_fixture_helpers
    self.send(:include, InstanceMethods)
  end

  def setup_client
    let(:client_config_params) do
      {
        address: "http://localhost:2113",
        user: "admin",
        password: "changeit"
      }
    end
    let(:client){ Nerve::EventStoreClient.new(client_config_params) }
  end

  module InstanceMethods
    def setup_stream_fixtures
      client.post_to_stream_request('test',{
        event_id: SecureRandom.uuid,
        topic: "test",
        foo: 'bar'
      })
    end

    def teardown_stream_fixtures
      client.delete_stream_request('test')
    end
  end
end

class ConnectionsController < ApplicationApiController
  include Connections

  serialization_scope :current_user

  # List all the connections for the logged in user
  def index
    render jsonapi: authorized_collection, each_serializer: Connection::Serializer
  end

  # Return json data for a connection
  def show
    connection = connection_from_params
    if connection.nil?
      head 404
    else
      render jsonapi: connection_from_params, serializer: Connection::Serializer
    end
  end

  # Use this endpoint to create a new connection
  def create
    event = Connection::Events::Create.from_jsonapi(params, self)
    result = event.handle
    render_resource_created_event result[:validation], result[:result]
  end

  private
  def create_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [:invited_email_address])
  end
end

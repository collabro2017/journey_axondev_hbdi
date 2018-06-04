class ConnectionEventsController < ApplicationApiController
  include Connections

  serialization_scope :current_user

  def index
    connection = connection_from_params
    if connection
      render jsonapi: connection_from_params.connection_events,
             each_serializer: ConnectionEvent::Serializer
    else
      head 404
    end
  end

  def show
    render jsonapi: connection_from_params.connection_events.find_by(uuid: unpack_uuid(params[:id])),
           serializer: ConnectionEvent::Serializer
  end

  def create
    event = ConnectionEvent::Events::Create.from_jsonapi(params, self)
    result = event.handle
    render_resource_created_event result[:validation], result[:result]
  end
end

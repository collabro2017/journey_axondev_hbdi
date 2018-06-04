module Connections
  extend ActiveSupport::Concern

  def authorized_collection
    Connection.filtered_for_user(current_user)
  end

  def connection_from_params
    id = params[:connection_id] || params[:id]
    @connection ||= authorized_collection.find_by(uuid: unpack_uuid(id))
  end
end

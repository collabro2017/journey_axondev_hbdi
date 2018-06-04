class ApplicationApiController < ActionController::Base
  include Authorization

  def unpack_uuid(packed)
    UUIDTools::UUID.parse_raw((packed + "==\n").tr('-_','+/').unpack('m*').first).to_s
  end

  def render_resource_created_event(validation, new_entity)
    render_params = {}
    if validation.errors.empty?
      render_params[:status] = 201
      render_params[:location] = connection_url(new_entity)
      render_params[:jsonapi] = new_entity
      render_params[:serializer] = new_entity.class::Serializer rescue nil
    else
      render_params[:jsonapi] = validation
      render_params[:serializer] = ActiveModel::Serializer::ErrorSerializer
      render_params[:status] = 422
    end

    render render_params
  end
end

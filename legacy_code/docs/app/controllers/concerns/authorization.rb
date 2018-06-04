module Authorization
  extend ActiveSupport::Concern

  def user_id
    request.headers['X-User-Id'] || Rails.application.config_for(:connect)['default_user']
  end

  def user_data
    data = request.headers['X-User-Data'] ? JSON.parse(request.headers['X-User-Data']) :
                                    Rails.application.config_for(:connect)['default_user_data']
    (data || {}).with_indifferent_access
  end

  def current_user
    Thinker.find_by(uuid: user_id)
  end
end

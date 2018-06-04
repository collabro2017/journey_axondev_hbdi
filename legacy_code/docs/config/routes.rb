Rails.application.routes.draw do
  scope :api do
    # /api/connections/:id
    resources :connections, only: [:create, :show, :index] do
      # /api/connections/:id/events
      resources :connection_events, path: '/events', only: [:create, :show, :index]
    end
  end
end

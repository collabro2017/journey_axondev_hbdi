class ConnectionsController < ApplicationApiController

  # List all the connections for the logged in user
  def index
    # Need to replace Thinker.all with AR Collection filtered by security
    render jsonapi: Thinker.all
  end

  # Return json data for a thinker
  def show
  end
end

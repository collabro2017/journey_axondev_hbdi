class HomeController < ApplicationController

  def index
    @base_url = ENV["RAILS_RELATIVE_URL_ROOT"]

  end
end

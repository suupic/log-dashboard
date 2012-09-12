class DashboardController < ApplicationController
  def index
  	@resources = Resource.all
  end
end

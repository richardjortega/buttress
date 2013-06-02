class AdminController < ApplicationController
  load_and_authorize_resource
  protect_from_forgery

  def index
  end

end
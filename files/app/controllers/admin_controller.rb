class AdminController < ApplicationController
  load_and_authorize_resource
  protect_from_forgery
  resourcify

  def index
  end

end
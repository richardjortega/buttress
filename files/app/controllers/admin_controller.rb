class AdminController < ApplicationController
  protect_from_forgery

  before_filter :authenticate_admin!

  # layout 'administration'

  def index
  end

end
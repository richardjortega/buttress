class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :userDecoratorToView

  private

  # A before filter to send a user decorator to the view
  def userDecoratorToView
    # @authed_user = UserDecorator.decorate(current_user)
    @authed_user = current_user
  end

  # A before filter for authing someone as an admin
  def authenticate_admin!
    redirect_to root_path unless current_user.present? && current_user.is_admin?
  end

  # Rescue from an access denied thrown by cancan
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

end
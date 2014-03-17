class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private
  def authenticate
    redirect_to :root and return unless session[:user_id].present?
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
  helper_method :current_user

  def trim_filter_tags_param
    params[:filter_tags].try(:reject!, &:blank?)
  end
end

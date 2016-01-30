class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  # redirect to login if not logged in
  def authorize
    redirect_to '/login' unless logged_in
  end

  # Authenticate User Method
  protected
  def authenticate_user
    unless session[:user_id]
      redirect_to login_path
      return false
    else
      # set current_user by the current user object
      @current_user = User.find session[:user_id]
      return true
    end
  end

  protected
  def check_login_state
    unless session[:user_id]
      return false
    else
      # set current_user by the current user object
      @current_user = User.find session[:user_id]
      return true
    end
  end

  #This method for prevent user to access Signup & Login Page without logout
  def save_login_state
    if session[:user_id]
      redirect_to welcome_index_path
      return false
    else
      return true
    end
  end
end
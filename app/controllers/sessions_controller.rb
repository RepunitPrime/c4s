class SessionsController < ApplicationController

  #Add authentication
  before_filter :authenticate_user, :except => [:index, :login, :logout]
  before_filter :save_login_state, :only => [:index, :login]

  # get login form
  def index
    if logged_in
      redirect_to articles_path
    end
    @user = User.new
  end

  # Login Action
  def login
    authorized_user = User.authenticate(sessions_params[:username_or_email],sessions_params[:login_password])
    if authorized_user
      log_in authorized_user
      redirect_to articles_path
    else
      #show error message that user is invalid
      flash.now[:notice] = "Invalid username/password"
      flash.now[:color]= "invalid"
      render 'index'
    end
  end

  # logout
  def logout
    log_out
    redirect_to login_path
  end

  # get login info object from http params
  def sessions_params
    params.require(:session).permit(:username_or_email,:login_password)
  end

end

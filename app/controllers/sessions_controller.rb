class SessionsController < ApplicationController

  #Add authentication
  before_filter :save_login_state, :only => [:index, :login]

  #Class Variable used to redirect to the right page in case user is not logged in.
  @@From;

  # get login form
  def index
    @user = User.new;
    @@From = params[:From];
  end

  # Login Action
  def login
    authorized_user = User.authenticate(sessions_params[:username_or_email],sessions_params[:login_password])

    if authorized_user && !authorized_user.activated?
      flash.now[:notice] = "Email address has not been verfied yet"
      flash.now[:color]= "invalid"
      render 'index'
    elsif authorized_user
      log_in authorized_user
      if(@@From.nil?)
        redirect_to welcome_index_path
      else
        redirect_to root_url + @@From.to_s[1..-1]
      end
    else
      @current_user= nil;
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

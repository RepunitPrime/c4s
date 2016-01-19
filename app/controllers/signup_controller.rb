class SignupController < ApplicationController

  before_filter :save_login_state, :only => [:new, :create]

  #create new user
  def new
    @user = User.new
  end

  # post action to create a new user (sign up)
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "You signed up successfully"
      flash[:color]= "valid"
      redirect_to articles_path
    else
      render 'signup'
    end
  end

  # get user object from http params
  def user_params
    params.require(:user).permit(:name,:username, :email, :password,:password_confirmation)
  end


end

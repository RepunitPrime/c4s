class SignupController < ApplicationController

  before_filter :save_login_state, :only => [:new, :create]

  # post action to create a new user (sign up)
  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.account_activation(@user).deliver_now
      flash[:color]= "valid"
      flash[:notice] = "An activation email has been sent."
      redirect_to login_url
    else
      render 'index'
    end
  end

  # get user object from http params
  def user_params
    params.require(:user).permit(:name,:username, :email, :password,:password_confirmation)
  end


end

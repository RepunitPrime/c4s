class AccountActivationsController < ApplicationController

  def index
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?('activation',params[:activation])
      user.activate
      redirect_to account_activations_show_path
    else
      flash[:color]= "invalidEmail"
      flash[:danger] = "Invalid Email Link"
      redirect_to login_url
    end
  end

  def show

  end
end

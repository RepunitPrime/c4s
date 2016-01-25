class PasswordResetsController < ApplicationController
  before_action :get_user,         only: [:edit]
  before_action :valid_user,       only: [:edit]
  before_action :check_expiration, only: [:edit]

  def new
  end

  def create
    @user = User.find_by_email(email_params[:email].to_s.downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:color]= "valid"
      flash[:notice] = "Email sent with password reset instructions"
      redirect_to login_path
    else
      flash[:color]= "invalid"
      flash.now[:notice] = "Email address not found"
      render 'new'
    end
  end

  def edit
  end

  def update
    @user = $user_reset;

      if(User.check_password_validity(pwd_params[:password]))
        if @user.update(pwd_params)
          flash[:notice] = "Password was successfully changed."
          flash[:color]= "valid"
          redirect_to login_path
        else
          if @user != nil && @user.errors
            for message_error in @user.errors.full_messages
              flash[:notice] = message_error
              flash[:color]= "invalid"
            end
          end
          render password_resets_edit_path
        end
      else
        flash.now[:notice] = "Password must be minimum of 6 characters."
        flash.now[:color]= "invalid"
        render password_resets_edit_path
      end
  end


  def pwd_params
    params.require(:user).permit(:password,:password_confirmation)
  end


  def email_params
    params.require(:user).permit(:email)
  end

  # Before filters

  def get_user
    @user = User.find_by(email: params[:email])
    $user_reset = @user;
  end

  # Confirms a valid user.
  def valid_user

    if (@user && @user.activated? &&
        !@user.authenticated?('reset', params[:reset]))
      flash[:color]= "invalid"
      flash[:notice] = "Password Token is incorrect. Please try again."
      redirect_to password_resets_new_url
    end
  end

  # Checks expiration of reset token.
  def check_expiration
    if @user.password_reset_expired?
      flash[:color]= "invalid"
      flash[:notice] = "Password reset has expired."
      redirect_to password_resets_new_url
    end
  end
end
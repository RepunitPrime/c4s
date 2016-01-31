class ProfileController < ApplicationController

  # add authentication for all actions
  before_filter :authorize

  def index
  end

  # get user for edit
  def edit
    @user=  User.find(current_user.id)
  end

  # post action for editing user
  def update
    @user = User.find(current_user.id)
    if @user.update(user_params)
      redirect_to profile_index_path
    else
      render profile_edit_path
    end
  end

  # post action for editing user's password
  def update_password
    @user = User.find(current_user.id)

    if User.authenticate(@user.username,pwd_params[:current_password])
      if(User.check_password_validity(pwd_params1[:password]))
        if @user.update(pwd_params1)
          flash[:notice] = "Password was successfully changed."
          flash[:color]= "valid"
          redirect_to profile_index_path
        else
          render profile_change_password_path
        end
      else
        flash.now[:notice] = "Password must be minimum of 6 characters."
        flash.now[:color]= "invalid"
        render profile_change_password_path
      end
    else
      flash.now[:notice] = "Wrong Current Password."
      flash.now[:color]= "invalid"
      render profile_change_password_path
    end
  end


  # get user object from http params
  def user_params
      params.require(:user).permit(:name,:username,:email,:profile_pic)
  end

  # get password objects from http params
  def pwd_params
    params.require(:user).permit(:current_password)
  end
  def pwd_params1
    params.require(:user).permit(:password,:password_confirmation)
  end

end


module SessionsHelper

  #log in the user
  def log_in(user)
    session[:user_id] = user.id
  end

  #return the current logged in user
  def current_user
    if @current_user.nil?
      @current_user = User.find_by(id: session[:user_id])
    else
    @current_user
    end
  end

  #return true if user is logged in already
  def logged_in()
    !current_user.nil?
  end

  #destroy the session and every detail about the user
  def log_out()
    session.delete(:user_id)
    @current_user = nil
  end

end

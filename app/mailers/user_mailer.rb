class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation"
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password Reset"
  end


   def user_notify(post)
   @post = post
   @user = post.user

      mail(to: @user.email, subject: 'Your post received a new comment')
   end

  def user_notify_Posted(user)
    @user = user
    @url = 'http://localhost:3000/posts'
    mail(to: @user.email, subject: 'Post Created Successfully')
  end

end

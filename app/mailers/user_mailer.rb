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
   @offer = post
   @user = post.user

      mail(to: @user.email, subject: 'Your post received a new comment')
   end

  def user_notify_Posted(user,offerId)
    @user = user
    @url = offer_url(offerId)
    mail(to: @user.email, subject: 'Offer Created Successfully')
  end

  def contact_seller(user,username,email,message,offerId)
    @user = user
    @username = username
    @email = email
    @message = message
    @url = offer_url(offerId)
    mail(to: user.email, subject: 'New Message about your offer')
  end

end

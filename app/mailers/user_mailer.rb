class UserMailer < ApplicationMailer

  default from: 'blog.c4s@gmail.com'

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


class AdCommentsController < ApplicationController


  def index
  end

  # post action to create a new comment
  def create
    if current_user.nil?
      redirect_to (login_path + '?From=/posts/'+ params[:post_id])
    else
      if params[:post_id].present?
        @post = Post.find(params[:post_id])
        @comment = @post.ad_comments.create(comment_params)
        @comment.user = current_user;
        @comment.save
        UserMailer.user_notify(@post).deliver
        redirect_to post_path(@post)
      else
        redirect_to login_url()
      end
    end
  end

  def destroy
    offer = Post.find(params[:post_id]);
    if !offer.nil?
      comment = AdComment.find(params[:id]);
      if !comment.nil?
        if current_user == comment.user
          comment.destroy;
          redirect_to post_path(params[:post_id]);
        else
          redirect_to login_path
        end
      end
    else
      redirect_to login_path
    end
  end

  # get comments object from http params
  private
  def comment_params
    params.require(:ad_comment).permit(:comment_body)
  end
end
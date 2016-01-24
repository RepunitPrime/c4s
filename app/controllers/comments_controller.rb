class CommentsController < ApplicationController

  # add authentication for all actions
  before_filter :authorize


  def index
  end

  # post action to create a new comment
  def create

    if params[:article_id].present?
      @article = Article.find(params[:article_id])
      @comment = @article.comments.create(comment_params)
      redirect_to article_path(@article)

    elsif params[:post_id].present?
      @post = Post.find(params[:post_id])
      @comment = @post.comments.create(comment_params)
      UserMailer.user_notify(@post).deliver
      redirect_to post_path(@post)
    else
      redirect_to login_url()
    end
  end


  # get comments object from http params
  private
  def comment_params
    params.require(:comment).permit(:username, :comment_body)
  end
end
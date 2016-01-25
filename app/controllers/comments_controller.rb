class CommentsController < ApplicationController

  # add authentication for all actions
  before_filter :authorize


  def index
  end

  # post action to create a new comment
  def create

    if params[:article_id].present?
	    @article = Article.find(params[:article_id])

	    @comment = @article.comment.create(comment_params)
	    @comment.user = @current_user;
	    @comment.save

	    @article.count_comments += 1;
	    @article.save;

	    $foo = true
	    redirect_to article_path(@article)

    elsif params[:post_id].present?
      @post = Post.find(params[:post_id])
      @comment = @post.comments.create(comment_params)
      @comment.user = @current_user;
      @comment.save
      UserMailer.user_notify(@post).deliver
      redirect_to post_path(@post)
    else
      redirect_to login_url()
    end

  end


  # get comments object from http params
  private
  def comment_params
    params.require(:comment).permit(:comment_body)
  end
end
class CommentsController < ApplicationController

  # add authentication for all actions
  before_filter :authorize


  def index
  end

  # post action to create a new comment
  def create
    @article = Article.find(params[:article_id])

    @comment = @article.comment.create(comment_params)
    @comment.user = @current_user;
    @comment.save

    @article.count_comments += 1;
    @article.save;

    $foo = true
    redirect_to article_path(@article)
  end


  # get comments object from http params
  private
  def comment_params
    params.require(:comment).permit(:comment_body)
  end
end
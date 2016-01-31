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

    else
      redirect_to login_path
    end

  end

  def destroy
    @article = Article.find(params[:article_id]);
    if !@article.nil?
        @comment = Comment.find(params[:id]);
        if !@comment.nil?
          if current_user == @comment.user
            @comment.destroy;
            @article.count_comments -= 1;
            @article.views -=1;
            @article.save;
            redirect_to article_path(params[:article_id]);
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
    params.require(:comment).permit(:comment_body)
  end
end
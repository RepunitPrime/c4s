class ArticlesController < ApplicationController

  # add authentication for all actions
  before_filter :authorize

  # show all articles
  def index
    @articles = Article.all
  end

  # get form page for creating
  def new

  end

  # post action to create a new article
  def create
    @article = Article.new(article_params)
    if @article.save
      redirect_to articles_path
    else
        render 'new'
    end
      
  end

  # show specific article
  def show
    @article = Article.find(params[:id]);
  end

  # get article for edit
  def edit
    @article = Article.find(params[:id])
  end

  # post action for editing article
  def update
    @article = Article.find(params[:id])

    if @article.update(article_params)
      redirect_to articles_path
    else
      render 'edit'
    end
  end

  # delete specific article
  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    redirect_to articles_path
  end

  private

  # get article object from http params
  def article_params
    params.require(:article).permit(:title, :text)
  end
end

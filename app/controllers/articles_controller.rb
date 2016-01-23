class ArticlesController < ApplicationController

  # add authentication for all actions
  before_filter :authorize
  #before_filter :authorize, only: [:create,:edit,:update,:destroy]

  # show all articles
  def index
    @articles = Article
    if params[:search]
      @articles = Article.search(params[:search]).order("created_at DESC").paginate(:page => params[:page], :per_page => 5)
      @srch = params[:search]
    else
      @articles = Article.paginate(:page => params[:page], :per_page => 5)
    end
  end

  # get form page for creating
  def new
    @topics = Topic.all
  end

  # post action to create a new article
  def create
    @article = Article.new(article_params)
    @article.user = @current_user;
    @topic = Topic.where(:topic_name => topic_params[:topic_name].to_s).first;

    if(@topic.nil?)
      @topic = Topic.new(topic_params)
      @topic.save
    else
      @article.topic = @topic;
    end

    if @article.save
      redirect_to articles_path
    else
      render 'new'
    end
  end

  # show specific article
  def show
    @article = Article.find(params[:id]);
    @article.views = @article.views + 1;
    @article.save;
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
    params.require(:article).permit(:title, :text,:Tags)
  end

  def topic_params
    params.require(:article).permit(:topic_name)
  end

  def article1_params
    params.require(:article).permit(:search)
  end

end

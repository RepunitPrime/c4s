class ArticlesController < ApplicationController

  # add authentication for all actions
  before_filter :authorize
  #before_filter :authorize, only: [:create,:edit,:update,:destroy]

  # show all articles
  def index
    if params[:search]
      @articles = Article.search(params[:search]).order("created_at DESC").paginate(:page => params[:page], :per_page => 5)
      @srch = params[:search]
    elsif !params[:popular_tag].nil?
      @articles = Article.searchByTag(params[:popular_tag]).order("created_at DESC").paginate(:page => params[:page], :per_page => 5)
      @selected_tag = params[:popular_tag].to_s.remove('[',']');
    else
      @articles = Article.paginate(:page => params[:page], :per_page => 5).order("created_at DESC")
    end
    @tags = Tag.order("count DESC").limit(10);
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

    #Add Topic to the Topic table if new
    if(@topic.nil?)
      @topic = Topic.new(topic_params)
      @topic.save
    else
      @article.topic = @topic;
    end

    @TagsSearch = '';
    #Add count of tags for statistic purposes
    if(!article_params[:Tags].nil?)
      split_tags = article_params[:Tags].to_s.split(',');
      split_tags.each do |tag|
        @tag = Tag.find_by_name(tag)
        @TagsSearch += '['+tag+']'
        if(@tag.nil?)
          @tag = Tag.new();
          @tag.name = tag;
          @tag.count = 1;
        else
          @tag.count += 1;
        end
        @tag.save
      end
      @article.tags_search= @TagsSearch;
    end

    if @article.save
      #Add File Attachments
      if !article2_params[:attach_file].nil?
        @article_attahments = ArticleAttachment.new();
        @article_attahments.attach_file = article2_params[:attach_file].tempfile;
        @article_attahments.article = @article;
        @article_attahments.save
      end

      redirect_to articles_path
    else
      @topics = Topic.all
      render 'articles/new'
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
  def article2_params
    params.require(:article).permit(:attach_file)
  end

end

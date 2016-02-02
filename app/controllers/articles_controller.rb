class ArticlesController < ApplicationController

  # add authentication for all actions
  before_filter :validate_if_user_logged_in, only: [:new ,:create ,:edit, :update, :destroy]

  # show all articles
  def index

    if params[:search]
      @articles = Article.search(params[:search]).order("created_at DESC").paginate(:page => params[:page], :per_page => 5)
      @srch = params[:search]
    elsif !params[:popular_tag].nil?
      @articles = Article.searchByTag(params[:popular_tag]).order("created_at DESC").paginate(:page => params[:page], :per_page => 5)
      @selected_tag = params[:popular_tag].to_s.remove('[',']')
    elsif !params[:popular_topic].nil?
      @articles = Article.searchByTopic(params[:popular_topic]).order("created_at DESC").paginate(:page => params[:page], :per_page => 5)
      @selected_topic = params[:popular_topic].to_s.remove('[',']')
    elsif !params[:most_popular].nil?
      @articles = Article.order("views DESC").paginate(:page => params[:page], :per_page => 5)
      @most_popular = true;
    elsif !params[:my_posts].nil? && !current_user.nil?
      @articles = Article.where("user_id= "+current_user.id.to_s).order("created_at DESC").paginate(:page => params[:page], :per_page => 5)
      @my_posts = true;
    else
      @articles = Article.order("created_at DESC").paginate(:page => params[:page], :per_page => 5)
    end

  end

  # get form page for creating
  def new

  end

  # post action to create a new article
  def create

    article = Article.new(article_params)
    article.user = current_user

    if article.save

      addTopic(topic_params[:topic_name].to_s,article)
      addTagsAndhandleTagCount(article)

      addAttachment(article,false)

      redirect_to articles_path
    else
      $text = article_params[:text];
      $tags = article_params[:Tags];
      $topic = topic_params[:topic_name];
      render 'articles/new'
    end
  end

  # show specific article
  def show
    @article = Article.find_by_id(params[:id]);
    if @article
      @article.views = @article.views + 1;
      @article.save;
    else
      redirect_to welcome_index_path
    end
  end

  # get article for edit
  def edit
    @article = Article.find_by_id(params[:id]);
    if !@article
      redirect_to welcome_index_path
    end
  end

  # post action for editing article
  def update

    article = Article.find(params[:id])
    prevTags = article.Tags
    if article.update(article_params)

      addTopic(topic_params[:topic_name].to_s,article)
      handleTagUpdates(prevTags)
      addTagsAndhandleTagCount(article)

      addAttachment(article,true)

      if article.save
        redirect_to articles_path
      else
        render 'edit'
      end
    else
      render 'edit'
    end
  end


  # delete specific article
  def destroy

    article = Article.find(params[:id])

    if article.tags_search
      split_tags = @article.tags_search.to_s.remove('[').to_s.split(']');
      split_tags.each do |tag|
        tempTag = Tag.find_by_name(tag)
        if(!tempTag.nil?)
          tempTag.count -= 1;
          if(tempTag.count == 0)
            tempTag.destroy
          else
            tempTag.save
          end
        end
      end
    end

    article.destroy
    redirect_to articles_path
  end

  def like
    article = Article.find(params[:id]);
    current_user.likes article
    article.views -= 1
    article.save
    redirect_to article_path(article)
  end

  def dislike
    article = Article.find(params[:id]);
    current_user.dislikes article
    article.views -= 1
    article.save
    redirect_to article_path(article)
  end

  # Handle Tags
  def addTagsAndhandleTagCount(article)

    tagsSearch = '';
    #Add count of tags for statistic purposes
    if(!article_params[:Tags].nil?)
      split_tags = article_params[:Tags].to_s.split(',');
      split_tags.each do |tag|
        tempTag = Tag.find_by_name(tag)
        tagsSearch += '['+tag+']'
        if(tempTag.nil?)
          tempTag = Tag.new();
          tempTag.name = tag;
          tempTag.count = 1;
        else
          tempTag.count += 1;
        end
        tempTag.save
      end
      article.tags_search= tagsSearch;
      article.save
    end
  end

  def handleTagUpdates(prevTags)

    if prevTags != article_params[:Tags]
      split_tags = prevTags.to_s.split(',');
      split_tags.each do |tag|
        tempTag = Tag.find_by_name(tag)
        if(!tempTag.nil?)
          tempTag.count -= 1;
          if(tempTag.count == 0)
            tempTag.destroy
          else
            tempTag.save
          end
        end
      end
    end
  end

  #Method to Add a Topic to the Article
  def addTopic(topic_name,article)
    topic = Topic.where(:topic_name => topic_name).first;
    #Add Topic to the Topic table if new
    if(topic.nil?)
      topic = Topic.new(topic_params)
      topic.save
      article.topic = topic
    else
      article.topic = topic
    end
    article.save
  end

  #Add File Attachment
  def addAttachment(article, isUpdate)
    if !attach_params[:attach_file].nil?
      #Delete PreviousAttachment
      if isUpdate
        _attachments = ArticleAttachment.where("article_id = "+article.id.to_s)
        if _attachments.any?
          _attachments.each do |attachment|
            attachment.destroy
          end
        end
      end
      # Add new Attachment
      article_attachments = ArticleAttachment.new()
      article_attachments.attach_file = attach_params[:attach_file].tempfile
      article_attachments.attach_file_file_name = attach_params[:attach_file].original_filename
      article_attachments.article = article
      article_attachments.save
    end
  end

  private
  def validate_if_user_logged_in
    if !check_login_state
      redirect_to (login_path + '?From='+ request.fullpath)
    end
  end

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
  def attach_params
    params.require(:article).permit(:attach_file)
  end

end

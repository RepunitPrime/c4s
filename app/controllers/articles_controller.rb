class ArticlesController < ApplicationController

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
      @articles = Article.paginate(:page => params[:page], :per_page => 5).order("views DESC")
      @most_popular = true;
    else
      @articles = Article.paginate(:page => params[:page], :per_page => 5).order("created_at DESC")
    end

    @tags = Tag.order("count DESC").limit(10)
    @PopularTopics = Article.selectByTopic().order("count DESC").limit(10)

  end

  # get form page for creating
  def new
    validate_if_user_logged_in
  end

  # post action to create a new article
  def create
    validate_if_user_logged_in

    article = Article.new(article_params)
    article.user = current_user

    if article.save

      topic = Topic.where(:topic_name => topic_params[:topic_name].to_s).first

      #Add Topic to the Topic table if new
      if(topic.nil?)
        topic = Topic.new(topic_params)
        topic.save
        article.topic = topic
      else
        article.topic = topic
      end

      tagsSearch = ''
      #Add count of tags for statistic purposes
      if(!article_params[:Tags].nil?)
        split_tags = article_params[:Tags].to_s.split(',')
        split_tags.each do |tag|
          tempTag = Tag.find_by_name(tag)
          tagsSearch += '['+tag+']'
          if(tempTag.nil?)
            tempTag = Tag.new()
            tempTag.name = tag
            tempTag.count = 1
          else
            tempTag.count += 1;
          end
          tempTag.save
        end
        article.tags_search= tagsSearch
        article.save
      end


      #Add File Attachments
      if !article2_params[:attach_file].nil?
        article_attahments = ArticleAttachment.new()
        article_attahments.attach_file = article2_params[:attach_file].tempfile
        article_attahments.attach_file_file_name = article2_params[:attach_file].original_filename
        article_attahments.article = article
        article_attahments.save
      end

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
    @article = Article.find(params[:id]);
    if($foo.nil?)
      @article.views = @article.views + 1;
      @article.save;
    else
      $foo = nil;
    end
  end

  # get article for edit
  def edit
    validate_if_user_logged_in
    @article = Article.find(params[:id])
  end

  # post action for editing article
  def update
    validate_if_user_logged_in

    article = Article.find(params[:id])
    prevTags = @article.Tags
    if article.update(article_params)

      topic = Topic.where(:topic_name => topic_params[:topic_name].to_s).first;

      #Add Topic to the Topic table if new
      if(topic.nil?)
        topic = Topic.new(topic_params)
        topic.save
        article.topic = topic
      else
        article.topic = topic
      end

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
          end
      end

      if article.save
        redirect_to articles_path
      else
        render 'edit'
      end
    else
      render 'edit'
    end
  end

  def like
    article = Article.find(params[:id]);
    current_user.likes article
    redirect_to article_path(article)
  end

  def dislike
    article = Article.find(params[:id]);
    current_user.dislikes article
    redirect_to article_path(article)
  end

  # delete specific article
  def destroy

    validate_if_user_logged_in

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
  def article2_params
    params.require(:article).permit(:attach_file)
  end

end

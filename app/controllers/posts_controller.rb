class PostsController < ApplicationController

  # add authentication for all actions
  before_filter :validate_if_user_logged_in, only: [:new ,:create ,:edit, :update, :destroy]

  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index

    if params[:search]
      if params[:ComingFrom] == 'Exchange'
        @Offers = Post.where("forSale = 'sale' ").order("created_at DESC").paginate(:page => params[:page], :per_page => 5)
        @OfferExchanges = Post.searchOffersForExchange(params[:search]).order("created_at DESC").paginate(:page => params[:page], :per_page => 5)
        @srch1 = params[:search]
      else
        @Offers = Post.searchOffersForSale(params[:search]).order("created_at DESC").paginate(:page => params[:page], :per_page => 5)
        @OfferExchanges = Post.where("forSale = 'exchange' ").order("created_at DESC").paginate(:page => params[:page], :per_page => 5)
        @srch = params[:search]
      end
    elsif !params[:popular_tag].nil?
      if params[:ComingFrom].nil?
        redirect_to posts_path
      else
        if params[:ComingFrom] == 'Sale'
          @Offers = Post.searchByTagForSale(params[:popular_tag]).order("created_at DESC").paginate(:page => params[:page], :per_page => 5)
          @OfferExchanges = Post.where("forSale = 'exchange' ").order("created_at DESC").paginate(:page => params[:page], :per_page => 5)
          @selected_tag = params[:popular_tag].to_s.remove('[',']')
        else
          @Offers = Post.where("forSale = 'sale' ").order("created_at DESC").paginate(:page => params[:page], :per_page => 5)
          @OfferExchanges = Post.searchByTagForExchange(params[:popular_tag]).order("created_at DESC").paginate(:page => params[:page], :per_page => 5)
          @selected_tag1 = params[:popular_tag].to_s.remove('[',']')
        end
      end
    else
      @Offers = Post.where("forSale = 'sale' ").order("created_at DESC").paginate(:page => params[:page], :per_page => 5)
      @OfferExchanges = Post.where("forSale = 'exchange' ").order("created_at DESC").paginate(:page => params[:page], :per_page => 5)
    end

    if params[:ComingFrom] == 'Exchange'
      @ComingFromExchange = true
    end

  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.user = current_user

    respond_to do |format|
      if @post.save
        addTagsAndhandleTagCount(@post)
        format.html { redirect_to @post }
        UserMailer.user_notify_Posted(current_user,@post.id.to_s).deliver
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update

    prevTags = @post.tags

    respond_to do |format|
      if @post.update(post_params)

        if prevTags != post_params[:tags]
          handleTagUpdates(prevTags,@post.forSale)
          addTagsAndhandleTagCount(@post)
        end

        format.html { redirect_to @post }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy

    if @post.tags_search
      split_tags = @post.tags_search.to_s.remove('[').to_s.split(']');
      split_tags.each do |tag|
        if @post.forSale == 'Sale'
          tempTag = OfferTagForSale.find_by_name(tag)
        else
          tempTag = OfferTagForExchange.find_by_name(tag)
        end
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

    forSale = @post.forSale

    @post.destroy
    if forSale =='sale'
      respond_to do |format|
        format.html { redirect_to posts_url}
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to posts_url+'?ComingFrom=Exchange'}
        format.json { head :no_content }
      end
    end

  end

  private

  # Handle Tags
  def addTagsAndhandleTagCount(post)

    tagsSearch = '';
    #Add count of tags for statistic purposes
    if !post_params[:tags].nil?
      split_tags = post_params[:tags].to_s.split(',');
      split_tags.each do |tag|
        if post.forSale == 'sale'
          tempTag = OfferTagForSale.find_by_name(tag)
        else
          tempTag = OfferTagForExchange.find_by_name(tag)
        end
        tagsSearch += '['+tag+']'

        if(tempTag.nil?)
          if post.forSale == 'sale'
            tempTag = OfferTagForSale.new()
          else
            tempTag = OfferTagForExchange.new()
          end
          tempTag.name = tag;
          tempTag.count = 1;
        else
          tempTag.count += 1;
        end
        tempTag.save
      end
      post.tags_search= tagsSearch;
      post.save
    end
  end

  def handleTagUpdates(prevTags, isForSale)

      split_tags = prevTags.to_s.split(',');
      split_tags.each do |tag|
        if isForSale = 'sale'
          tempTag = OfferTagForSale.find_by_name(tag)
        else
          tempTag = OfferTagForExchange.find_by_name(tag)
        end

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

  def validate_if_user_logged_in
    if !check_login_state
      redirect_to (login_path + '?From='+ request.fullpath)
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def post_params
    params.require(:post).permit(:title, :detail, :image, :isDeleted, :forSale, :cost, :bookexpected,:tags)
  end
end

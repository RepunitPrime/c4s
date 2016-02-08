class OffersController < ApplicationController

  # add authentication for all actions
  before_filter :validate_if_user_logged_in, only: [:new ,:create ,:edit, :update, :destroy]

  before_action :set_offer, only: [:show, :edit, :update, :destroy]

  # GET /offers
  # GET /offers.json
  def index

    if params[:search]
      if params[:ComingFrom] == 'Exchange'
        @Offers = Offer.where("forSale = 'sale' ").order("created_at DESC").paginate(:page => params[:page], :per_page => 5)
        @OfferExchanges = Offer.searchOffersForExchange(params[:search]).order("created_at DESC").paginate(:page => params[:page], :per_page => 5)
        @srch1 = params[:search]
      else
        @Offers = Offer.searchOffersForSale(params[:search]).order("created_at DESC").paginate(:page => params[:page], :per_page => 5)
        @OfferExchanges = Offer.where("forSale = 'exchange' ").order("created_at DESC").paginate(:page => params[:page], :per_page => 5)
        @srch = params[:search]
      end
    elsif !params[:popular_tag].nil?
      if params[:ComingFrom].nil?
        redirect_to offers_path
      else
        if params[:ComingFrom] == 'Sale'
          @Offers = Offer.searchByTagForSale(params[:popular_tag]).order("created_at DESC").paginate(:page => params[:page], :per_page => 5)
          @OfferExchanges = Offer.where("forSale = 'exchange' ").order("created_at DESC").paginate(:page => params[:page], :per_page => 5)
          @selected_tag = params[:popular_tag].to_s.remove('[',']')
        else
          @Offers = Offer.where("forSale = 'sale' ").order("created_at DESC").paginate(:page => params[:page], :per_page => 5)
          @OfferExchanges = Offer.searchByTagForExchange(params[:popular_tag]).order("created_at DESC").paginate(:page => params[:page], :per_page => 5)
          @selected_tag1 = params[:popular_tag].to_s.remove('[',']')
        end
      end
    else
      @Offers = Offer.where("forSale = 'sale' ").order("created_at DESC").paginate(:page => params[:page], :per_page => 5)
      @OfferExchanges = Offer.where("forSale = 'exchange' ").order("created_at DESC").paginate(:page => params[:page], :per_page => 5)
    end

    if params[:ComingFrom] == 'Exchange'
      @ComingFromExchange = true
    end

  end

  # GET /offers/1
  # GET /offers/1.json
  def show
    if params[:Contact_comment] && current_user
      offer = Offer.find(params[:id])
      UserMailer.contact_seller(offer.user,params[:Contact_name],params[:Contact_Email],params[:Contact_comment],offer.id.to_s).deliver_now
      redirect_to offer_path(offer)
    end
  end

  # GET /offers/new
  def new
    @offer = Offer.new
  end

  # GET /offers/1/edit
  def edit
  end

  # POST /offers
  # POST /offers.json
  def create
    @offer = Offer.new(offer_params)
    @offer.user = current_user

    respond_to do |format|
      if @offer.save
        addTagsAndhandleTagCount(@offer)
        format.html { redirect_to @offer }
        if current_user.getEmailNotified
          UserMailer.user_notify_Posted(current_user, @offer.id.to_s).deliver
        end
        format.json { render :show, status: :created, location: @offer }
      else
        format.html { render :new }
        format.json { render json: @offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /offers/1
  # PATCH/PUT /offers/1.json
  def update

    prevTags = @offer.tags

    respond_to do |format|
      if @offer.update(offer_params)

        if prevTags != offer_params[:tags]
          handleTagUpdates(prevTags, @offer.forSale)
          addTagsAndhandleTagCount(@offer)
        end

        format.html { redirect_to @offer }
        format.json { render :show, status: :ok, location: @offer }
      else
        format.html { render :edit }
        format.json { render json: @offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /offers/1
  # DELETE /offers/1.json
  def destroy

    if @offer.tags_search
      split_tags = @offer.tags_search.to_s.remove('[').to_s.split(']');
      split_tags.each do |tag|
        if @offer.forSale == 'sale'
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

    forSale = @offer.forSale

    @offer.destroy
    if forSale =='sale'
      respond_to do |format|
        format.html { redirect_to offers_url}
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to offers_url+'?ComingFrom=Exchange'}
        format.json { head :no_content }
      end
    end

  end

  private

  # Handle Tags
  def addTagsAndhandleTagCount(offer)

    tagsSearch = '';
    #Add count of tags for statistic purposes
    if !offer_params[:tags].nil?
      split_tags = offer_params[:tags].to_s.split(',');
      split_tags.each do |tag|
        if offer.forSale == 'sale'
          tempTag = OfferTagForSale.find_by_name(tag)
        else
          tempTag = OfferTagForExchange.find_by_name(tag)
        end
        tagsSearch += '['+tag+']'

        if(tempTag.nil?)
          if offer.forSale == 'sale'
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
      offer.tags_search= tagsSearch;
      offer.save
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
  def set_offer
    @offer = Offer.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def offer_params
    params.require(:offer).permit(:title, :detail, :image, :isDeleted, :forSale, :cost, :bookexpected, :tags)
  end
end

class OfferCommentsController < ApplicationController


  def index
  end

  # post action to create a new comment
  def create
    if current_user.nil?
      redirect_to (login_path + '?From=/offers/'+ params[:offer_id])
    else
      if params[:offer_id].present?
        @offer = Offer.find(params[:offer_id])
        @comment = @offer.offer_comments.create(comment_params)
        @comment.user = current_user;
        @comment.save
        if current_user.getEmailNotified
          UserMailer.user_notify(@offer).deliver
        end

        redirect_to offer_path(@offer)
      else
        redirect_to login_url()
      end
    end
  end

  def destroy
    offer = Offer.find(params[:offer_id]);
    if !offer.nil?
      comment = OfferComment.find(params[:id]);
      if !comment.nil?
        if current_user == comment.user
          comment.destroy;
          redirect_to offer_path(params[:offer_id]);
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
    params.require(:offer_comment).permit(:comment_body)
  end
end
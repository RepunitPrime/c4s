require 'test_helper'

class OffersControllerTest < ActionController::TestCase
  setup do
    @offer = offers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:offers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create post" do
    assert_difference('Offer.count') do
      post :create, offer: { attachment: @offer.attachment, detail: @offer.detail, isDeleted: @offer.isDeleted, title: @offer.title, topic: @offer.topic, user_id: @offer.user_id }
    end

    assert_redirected_to post_path(assigns(:offer))
  end

  test "should show post" do
    get :show, id: @offer
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @offer
    assert_response :success
  end

  test "should update post" do
    patch :update, id: @offer, offer: { attachment: @offer.attachment, detail: @offer.detail, isDeleted: @offer.isDeleted, title: @offer.title, topic: @offer.topic, user_id: @offer.user_id }
    assert_redirected_to post_path(assigns(:offer))
  end

  test "should destroy post" do
    assert_difference('Offer.count', -1) do
      delete :destroy, id: @offer
    end

    assert_redirected_to offers_path
  end
end

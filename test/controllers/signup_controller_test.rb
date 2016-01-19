require 'test_helper'

class SignupControllerTest < ActionController::TestCase
  test "should get signup" do
    get :signup
    assert_response :success
  end

end

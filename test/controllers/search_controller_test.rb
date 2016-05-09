require 'test_helper'

class SearchControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success
  end

  test "should get result" do
    get :result
    assert_response :success
  end

end

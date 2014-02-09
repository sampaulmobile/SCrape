require 'test_helper'

class DropboxControllerTest < ActionController::TestCase
  test "should get connect" do
    get :connect
    assert_response :success
  end

  test "should get connected" do
    get :connected
    assert_response :success
  end

end

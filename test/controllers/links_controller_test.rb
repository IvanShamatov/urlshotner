require 'test_helper'

class LinksControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get create" do
    get :create
    assert_response :success
  end

  test "should get move" do
    get :move
    assert_response :success
  end

end

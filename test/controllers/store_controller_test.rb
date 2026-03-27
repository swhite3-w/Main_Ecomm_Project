require "test_helper"

class StoreControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get store_index_url
    assert_response :success
  end

  test "should get show" do
    get store_show_url
    assert_response :success
  end

  test "should get category" do
    get store_category_url
    assert_response :success
  end

  test "should get about" do
    get store_about_url
    assert_response :success
  end
end

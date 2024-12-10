require "test_helper"

class ChildrenControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get children_new_url
    assert_response :success
  end

  test "should get create" do
    get children_create_url
    assert_response :success
  end

  test "should get show" do
    get children_show_url
    assert_response :success
  end

  test "should get declare_done" do
    get children_declare_done_url
    assert_response :success
  end
end

require "test_helper"

class FamiliesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get families_create_url
    assert_response :success
  end
end

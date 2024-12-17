require "test_helper"

class FamilyTasksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get family_tasks_index_url
    assert_response :success
  end
end

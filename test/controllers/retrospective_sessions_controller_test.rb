require "test_helper"

class RetrospectiveSessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get retrospective_sessions_show_url
    assert_response :success
  end
end

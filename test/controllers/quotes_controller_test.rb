require 'test_helper'

class QuotesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get quotes_show_url
    assert_response :success
  end

end

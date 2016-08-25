require 'test_helper'

class RegistrationControllerTest < ActionController::TestCase
  test "should get registration" do
    get :registration
    assert_response :success
  end

end

require 'test_helper'

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  should "create a new cart for a new session" do
    assert_difference("Cart.count") do
      get "/"
      assert_response :success
      assert session[:cart_id].present?
    end
  end
end
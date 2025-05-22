require 'test_helper'

class CartsControllerTest < ActionDispatch::IntegrationTest
  context "Cart" do
    should "show current cart" do
      get cart_path(:current_cart)
      assert_response :success
    end
  end
end

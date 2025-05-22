require 'test_helper'

class ItemsControllerTest < ActionDispatch::IntegrationTest
  context "Items" do
    should "be created and added to cart successfully" do
      assert_difference("Cart.count" => 1, "Item.count" => 1) do
        post items_url, params: { item: { product_id: products(:product_one).id, amount: 1 } }
        assert_equal("Cart was successfully updated.", flash[:notice])
        assert_redirected_to cart_path(Cart.last)
      end
    end

    should "be successfully updated with new amount if item with a similar product was already added to the cart" do
      post items_url, params: { item: { product_id: products(:product_one).id, amount: 1 }}
      assert_no_changes("Item.count", 1) do
        post items_url, params: { item: { product_id: products(:product_one).id, amount: 3 }}
        assert_equal("Cart was successfully updated.", flash[:notice])
        assert_redirected_to cart_path(Cart.last)
      end
    end

    should "notify if cart item creation failed because of invalid parameters" do
      expected_error_message = "Could not add item to cart: Validation failed: Amount must be greater than 0"
      assert_difference("Cart.count" => 1, "Item.count" => 0) do
        post items_url, params: { item: { product_id: products(:product_one).id, amount: -42 }}
        assert_equal(expected_error_message, flash[:error])
        assert_nil(flash[:notice])
        assert_redirected_to products_path
      end
    end

    should "raise exception if request does not contain expected parameters" do
      post items_url, params: { item: { foo: 42 }}
      assert_response :bad_request
      assert response.body.include?('param is missing or the value is empty or invalid')
    end

    should "update product amount of the item" do
      skip("Add factory bot")
      post update_cart_item_url, params: { item: { item_id: items(:first_goodie_item), amount: 6 } }
      assert_equal("Cart item was successfully updated.", flash[:notice])
      assert_nil(flash[:error])
      assert_redirected_to current_cart_path
    end
  end
end

require 'test_helper'

class CartTest < ActiveSupport::TestCase
  context "Cart" do
    should "be created successfully" do
      assert_difference('Cart.count', 1) do
        Cart.create(items: [])
      end
    end

    should "update product amount if added item is already in the cart" do
      cart = carts(:one)
      assert_no_changes("Item.count") do
        cart.add_item(product_id: products(:product_one).id, amount: 1)
        assert_equal(1, cart.items.count)
        assert_equal(2, cart.items.first.amount)
      end
    end

    should "create a new item and add successfully it to the cart" do
      cart = carts(:one)
      assert_difference("Item.count") do
        cart.add_item(product_id: products(:product_two).id, amount: 4)
        assert_equal(2, cart.items.count)
      end
    end

    should "raise exception if item validation failed due to exceeding stock amount" do
      cart = carts(:one)
      expected_error_message = "Could not add item to cart: Validation failed: Product Second Goodie has only 24 item(s) left in the stock."
      cart.add_item(product_id: products(:product_two).id, amount: 9999)
      assert cart.errors.present?
      assert_equal(expected_error_message, cart.errors.full_messages.join("."))
    end

    should "count total sum" do
      cart = carts(:one)
      cart.add_item(product_id: products(:product_two).id, amount: 1)

      expected_sum = products(:product_one).price + products(:product_two).price
      assert_equal(expected_sum, cart.total_sum)
    end
  end
end

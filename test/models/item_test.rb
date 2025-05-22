require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  context "Item" do
    should "be created successfully" do
      assert_difference('Item.count', 1) do
        Item.create(amount: 1, product: products(:product_one), cart: carts(:one))
      end
    end

    should "not pass validation if amount is missing" do
      item = Item.new(product: products(:product_one), cart: carts(:one))
      exception = assert_raise(ActiveRecord::RecordInvalid) { item.validate! }
      assert_equal("Validation failed: Amount can't be blank, Amount is not a number", exception.message)
    end

    should "not pass validation if amount is not Integer" do
      item = Item.new(amount: 4.2, product: products(:product_one), cart: carts(:one))
      exception = assert_raise(ActiveRecord::RecordInvalid) { item.validate! }
      assert_equal("Validation failed: Amount must be an integer", exception.message)
    end

    should "not pass validation if stock does not have enough amount" do
      item = Item.new(amount: 999, product: products(:product_one), cart: carts(:one))
      exception = assert_raise(ActiveRecord::RecordInvalid) { item.validate! }
      assert_equal("Validation failed: Product First Goodie has only 42 item(s) left in the stock.", exception.message)
    end

    should "not pass validation if product is missing" do
      item = Item.new(amount: 1, cart: carts(:one))
      exception = assert_raise(ActiveRecord::RecordInvalid) { item.validate! }
      assert_equal("Validation failed: Product must exist, Product is not valid or is not active.", exception.message)
    end

    context "amount" do
      should "be validated on update if amount changes" do
        item = items(:first_goodie_item)
        item.expects(:enough_product_in_stock).once
        item.update!(amount: 4)
      end

      should "be validated on update if amount remains the same" do
        item = items(:first_goodie_item)
        item.expects(:enough_product_in_stock).once
        item.update!(amount: item.amount)
      end

      should "be validated on update if amount more than available in stock" do
        item = items(:first_goodie_item)
        exception = assert_raise(ActiveRecord::RecordInvalid) { item.update!(amount: 99999) }

        expected_error_message = "Validation failed: Product #{item.product.name} has only #{item.product.stock} item(s) left in the stock."
        assert_equal(expected_error_message, exception.message)
      end

      should "be validated on increase by N" do
        item = items(:first_goodie_item)
        old_amount = item.amount
        item.expects(:enough_product_in_stock).once
        item.increase_amount(2)
        assert_equal(old_amount + 2, item.amount)
      end

      should "not be increased by N if no more product in stock" do
        item = items(:first_goodie_item)
        old_amount = item.amount
        exception = assert_raise(ActiveRecord::RecordInvalid) { item.increase_amount(999) }

        expected_error_message = "Validation failed: Product #{item.product.name} has only #{item.product.stock} item(s) left in the stock."
        assert_equal(expected_error_message, exception.message)
      end
    end
  end
end

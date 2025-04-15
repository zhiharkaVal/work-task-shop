require 'test_helper'

class ProductHelperTest < ActionView::TestCase
  test "should return min price if there are any products" do
    expected_value = Product.find_by_name("Lowest Price Goodie").price
    assert_equal expected_value, min_products_price
  end

  test "should return max price if there are any products" do
    expected_value = Product.find_by_name("Highest Price Goodie").price
    assert_equal expected_value, max_products_price
  end

  test "should return default min price if there is no products" do
    Product.stub :minimum, nil do
      assert_equal Product::DEFAULT_MIN_PRODUCT_PRICE, min_products_price
    end
  end

  test "should return default max price if there is no products" do
    Product.stub :maximum, nil do
      assert_equal Product::DEFAULT_MAX_PRODUCT_PRICE, max_products_price
    end
  end

  test "should return rounded min price if price has decimals" do
    Product.stub :minimum, 2.25 do
      assert_equal 2, min_products_price
    end
  end

  test "should return rounded max price if price has decimals" do
    Product.stub :maximum, 42.99 do
      assert_equal 43, max_products_price
    end
  end
end

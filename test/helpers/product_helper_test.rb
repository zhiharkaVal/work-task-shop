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
    Product.stubs(:minimum).returns(nil)
    assert_equal Product::DEFAULT_MIN_PRODUCT_PRICE, min_products_price
  end

  test "should return default max price if there is no products" do
    Product.stubs(:maximum).returns(nil)
    assert_equal Product::DEFAULT_MAX_PRODUCT_PRICE, max_products_price
  end

  test "should return rounded min price if price has decimals" do
    Product.stubs(:minimum).returns(2.25)
    assert_equal 2, min_products_price
  end

  test "should return zero for min price if price is between zero and one" do
    Product.stubs(:minimum).returns(0.85)
    assert_equal 0, min_products_price
  end

  test "should return rounded max price if price has decimals" do
    Product.stubs(:maximum).returns(42.37)
    assert_equal 43, max_products_price
  end
end

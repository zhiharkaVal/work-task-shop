require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get products_url
    assert_response :success
  end

  test "should show specific existing product" do
    product = products(:one)

    get product_url(product)
    assert_response :success
  end

  test "should save new product" do
    get new_product_url
    assert_response :success

    assert_difference("Product.count") do
      post products_url, params: { product: { name: "Best product ever", price: 42, stock: 1 } }
      assert_redirected_to product_path(Product.last)
    end
  end

  test "should stay on new product page, if product validation fails" do
    get new_product_url
    post products_url, params: { product: { name: "Best product ever", price: 42, stock: -1 } }
    assert_equal("Stock must be greater than or equal to 0", assigns(:product).errors.full_messages.first)
  end

  test "should update existing product" do
    product = products(:one)
    get edit_product_url(product)
    assert_response :success

    patch product_url(product), params: { product: { stock: 62, price: 42 } }
    assert_redirected_to product_url(product)
    assert_equal 62, Product.find(product.id).stock
  end

  test "should not update existing product, if it does not pass validation" do
    expected_error_messages = ["Price must be greater than 0", "Stock must be greater than or equal to 0"]
    product = products(:one)
    get edit_product_url(product)
    assert_response :success

    patch product_url(product), params: { product: { stock: -62, price: 0 } }
    assert_equal(expected_error_messages, assigns(:product).errors.full_messages)
  end

  test "should delete product" do
    product = Product.create(name: "To be deleted", price: 29, stock: 1)
    assert_difference('Product.count', -1) do
      delete product_url(product)
    end
    assert_redirected_to products_url
  end

  test "should sort products by price" do
    get search_url, params: { sorting_options: "price" }
    assert_response :success
  end

  test "should sort products by name" do
    get search_url, params: { sorting_options: "name", name: "Fi" }
    assert_response :success
  end
end

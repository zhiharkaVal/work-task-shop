require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  context "Product" do
    should "be saved successfully" do
      assert_difference('Product.count', 1) do
        Product.create(name: "Unicorn", price: 42.42, stock: 42)
      end
    end

    should "be validated before saving" do
      product = Product.new()
      product.validate
      assert_equal(3, product.errors.count)
      assert_includes(product.errors.full_messages, "Price is not a number")
    end

    should "have unique name" do
      product = Product.new(name: "Lowest Price Goodie", price: 1.23, stock: 42)
      exception = assert_raise(ActiveRecord::RecordInvalid) { product.validate! }
      assert_equal("Validation failed: Name has already been taken", exception.message)
    end

    should "have a valid price" do
      product = Product.new(name: "Batmobile", price: 0, stock: 12)
      exception = assert_raise(ActiveRecord::RecordInvalid) { product.validate! }
      assert_equal("Validation failed: Price must be greater than 0", exception.message)
    end

    should "have a valid stock" do
      product = Product.new(name: "Batmobile", price: 99999999, stock: 0.1)
      exception = assert_raise(ActiveRecord::RecordInvalid) { product.validate! }
      assert_equal("Validation failed: Stock must be an integer", exception.message)
    end
  end

  context "Product stock" do
    should "be successfully updated with purchased items amount" do
      product = Product.find_by_name("First Goodie")
      assert_difference('product.stock', -2) do
        product.purchase!(2)
      end
    end

    should "not be updated if stock is smaller than purchased amount" do
      product = Product.find_by_name("First Goodie")
      assert_no_changes('product.stock') do
        product.purchase!(9999999)
      end
      assert_equal("Product 'First Goodie' has only 42 left in the stock.", product.errors.full_messages.join(' '))
    end

    should "not be updated if purchased amount is less than zero" do
      product = Product.find_by_name("First Goodie")
      assert_no_changes('product.stock') do
        product.purchase!(-42)
      end
      assert_equal("Purchased amount cannot be negative!", product.errors.full_messages.join(' '))
    end

    should "not change if purchased amount is zero" do
      product = Product.find_by_name("First Goodie")
      assert_no_changes('product.stock') do
        product.purchase!(0)
      end
      assert(product.errors.empty?)
    end

    should "be successfully updated" do
      product = Product.find_by_name("First Goodie")
      assert_difference('product.stock', 2) do
        product.restock!(2)
      end
    end

    should "not be updated if stock is less than zero" do
      product = Product.find_by_name("First Goodie")
      assert_no_changes('product.stock') do
        product.restock!(-10)
      end
      assert_equal("Restock amount cannot be negative!", product.errors.full_messages.join(' '))
    end

    should "not change if restock amount is zero" do
      product = Product.find_by_name("First Goodie")
      assert_no_changes('product.stock') do
        product.restock!(0)
      end
      assert(product.errors.empty?)
    end
  end

  context "Products search" do
    should "return all products within min and max range unsorted" do
      search_result = Product.search_by(Product::DEFAULT_MIN_PRODUCT_PRICE, Product::DEFAULT_MAX_PRODUCT_PRICE, '', '')
      assert_equal(4, search_result.count)
      assert_equal("Second Goodie|Lowest Price Goodie|Highest Price Goodie|First Goodie", search_result.map(&:name).join('|'))
    end

    should "return sorted by price products within given min and max range" do
      search_result = Product.search_by(43, Product::DEFAULT_MAX_PRODUCT_PRICE, '', "price ASC")
      assert_equal(2, search_result.count)
      assert_equal("First Goodie|Highest Price Goodie", search_result.map(&:name).join('|'))
    end

    should "return sorted by name products with a given name" do
      search_result = Product.search_by(Product::DEFAULT_MIN_PRODUCT_PRICE, Product::DEFAULT_MAX_PRODUCT_PRICE, 'price', "name ASC")
      assert_equal(2, search_result.count)
      assert_equal("Highest Price Goodie|Lowest Price Goodie", search_result.map(&:name).join('|'))
    end
  end
end

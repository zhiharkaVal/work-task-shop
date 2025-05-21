module ProductHelper
  def min_products_price
    if Product.count > 0 && Product.minimum(:price).present?
      Product.minimum(:price).floor
    else
      Product::DEFAULT_MIN_PRODUCT_PRICE
    end
  end

  def max_products_price
    if Product.count > 0 && Product.maximum(:price).present?
      Product.maximum(:price).ceil
    else
      Product::DEFAULT_MAX_PRODUCT_PRICE
    end
  end
end

class ProductsController < ApplicationController
  include ProductHelper
  def index
    @products = Product.paginate(page: params[:page], per_page: 10)
    @item = current_cart.items.new
  end

  def new
    @product = Product.new
  end

  def show
    @product = Product.find(params[:id])
  end

  def edit
    @product = Product.find(params[:id])
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to @product
    else
      render 'new'
    end
  end

  # If any changes have been made in the edit form of the product, they will be saved to the database
  def update
    @product = Product.find(params[:id])

    if @product.update(product_params)
      redirect_to @product
    else
      render 'edit'
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    redirect_to products_path
  end

  # If user made a query by the beginning of the product name, displays products meeting the query.
  # Within the search (or in case user wants just to sort products) the products could be sorted in ascending order,
  # by name or by price.
  # User also could select product within particular price range.
  def search
    min_price = params[:price_min].present? ? params[:price_min] : min_products_price
    max_price = params[:price_max].present? ? params[:price_max] : max_products_price
    sort_by = if (params[:sorted_name] == "true")
                "name ASC"
              elsif (params[:sorted_price] == "true")
                "price ASC"
              else
                ""
              end

    @products = Product.search_by(min_price, max_price, params[:name], sort_by)
                  .paginate(page: params[:page], per_page: 10)
  end

  private
  def product_params
    params.expect(product: [:name, :stock, :price])
  end
end

class ItemsController < ApplicationController
  def create
    @cart.add_item(item_params.transform_values!(&:to_i))

    if @cart.errors.present?
      flash[:error] = @cart.errors.full_messages.join(".")
      redirect_to products_path and return
    end

    flash[:notice] = "Cart was successfully updated."
    redirect_to current_cart
  end

  def update
    item_id = params.dig(:item, :item_id).to_i
    updated_amount_to_purchase = params.dig(:item, :amount).to_i
    render 'cart/show' and return if updated_amount_to_purchase == 0
    @cart.items.update!(item_id, amount: updated_amount_to_purchase)

    flash[:notice] = "Cart item was successfully updated."
    redirect_to current_cart
  rescue StandardError => e
    flash[:error] = e.message
    redirect_to current_cart
  end

  def destroy
    @cart.items.delete(params[:id])

    flash[:notice] = "Cart was successfully updated."
    redirect_to current_cart
  rescue StandardError => e
    flash[:error] = "Could not delete product from cart: #{e.message}."
    redirect_to current_cart
  end

  private
  def item_params
    params.expect(item: [:amount, :product_id])
  end
end
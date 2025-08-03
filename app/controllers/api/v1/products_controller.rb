class Api::V1::ProductsController < ApplicationController
  def create
    user = User.find_or_create_by(telegram_id: params[:telegram_id])
    # Use find_or_create_by to avoid duplicates
    product = user.products.find_or_create_by(name: product_params[:name])
    # Update the category in case it has changed
    product.category_id = product_params[:category_id]

    if product.save
      render json: product, status: :created
    else
      render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :category_id)
  end
end
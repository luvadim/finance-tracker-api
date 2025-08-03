# app/controllers/api/v1/categories_controller.rb

class Api::V1::CategoriesController < ApplicationController
  # This controller handles creating and listing spending/income categories (e.g., Groceries, Salary).

  # GET /api/v1/categories
  # Fetches all categories for a given user.
  # The bot must provide the telegram_id as a query parameter.
  # Example: GET /api/v1/categories?telegram_id=12345
  def index
    user = User.find_by(telegram_id: params[:telegram_id])

    if user
      categories = user.categories
      render json: categories, status: :ok
    else
      # If the user doesn't exist, they have no categories. Return an empty array.
      render json: [], status: :ok
    end
  end

  # POST /api/v1/categories
  # Creates a new category for a user.
  # The bot must send telegram_id and category data in the JSON body.
  def create
    # Find the user by the ID the bot sent. If they don't exist, create them.
    user = User.find_or_create_by(telegram_id: params[:telegram_id])

    # Build the category belonging to that specific user.
    category = user.categories.build(category_params)

    if category.save
      render json: category, status: :created
    else
      render json: { errors: category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  # Strong Parameters for security.
  def category_params
    params.require(:category).permit(:name)
  end
end

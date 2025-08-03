class Api::V1::TransactionsController < ApplicationController
  # We don't need `before_action :authenticate_user!` because our
  # ApplicationController is already checking for the bot's secret API key.

  # GET /api/v1/transactions
  # The bot must include the telegram_id in the request's query params
  # Example request from the bot: GET /api/v1/transactions?telegram_id=12345
  def index
    user = User.find_by(telegram_id: params[:telegram_id])

    if user
      # Scoping to the user is crucial for security and correctness
      transactions = user.transactions.order(transaction_date: :desc)
      render json: transactions, status: :ok
    else
      # If the user doesn't exist, return an empty array.
      render json: [], status: :ok
    end
  end

  # POST /api/v1/transactions
  # The bot must send the telegram_id and transaction data in the JSON body.
  def create
    user = User.find_or_create_by(telegram_id: params[:telegram_id])
    description = transaction_params[:description]

    # If category_id is provided, create the transaction directly
    if transaction_params[:category_id].present?
      return create_transaction_with_category(user, transaction_params[:category_id])
    end

    # If not, try to find a matching product
    product = user.products.find_by('lower(name) = ?', description.downcase)

    if product
      # Category found via Product! Create the transaction.
      create_transaction_with_category(user, product.category_id)
    else
      # Category not found. Respond with a special status to tell the bot to ask the user.
      render json: { status: 'category_required' }, status: :not_found
    end
  end

  private
  def create_transaction_with_category(user, category_id)
    # Merge the found or provided category_id into the params
    full_params = transaction_params.merge(category_id: category_id)
    transaction = user.transactions.build(full_params)

    if transaction.save
      render json: transaction, status: :created
    else
      render json: { errors: transaction.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def transaction_params
    # Make category_id optional in the initial request
    params.require(:transaction).permit(
      :description,
      :amount,
      :transaction_type,
      :transaction_date,
      :account_id,
      :category_id,
    )
  end
  # # This is a "strong params" method. It's a security feature to prevent
  # # users from updating model fields they aren't supposed to.
  # def transaction_params
  #   params.require(:transaction).permit(
  #     :description,
  #     :amount,
  #     :transaction_type,
  #     :transaction_date,
  #     :account_id,
  #     :category_id
  #   )
  # end
end
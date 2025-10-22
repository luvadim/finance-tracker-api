class Api::V1::TransactionsController < ApplicationController
  # Use a before_action to find the user for all actions, keeping your code DRY.
  before_action :set_user

  # GET /api/v1/transactions
  def index
    transactions = @user.transactions.by_date_range(params[:start_date], params[:end_date])

    render json: transactions.order(transaction_date: :desc), status: :ok
  end

  # POST /api/v1/transactions
  def create
    if params[:voice_url].present?
      processed_transactions = Transactions::ProcessVoiceMessage.call(params[:voice_url], @user, transaction_params)

      render json: processed_transactions, status: :created
    else
      result = Transactions::CreateFromParams.call(@user, transaction_params)

      # The service object's result tells us what response to render.
      if result.success?
        render json: result.transaction, status: :created
      elsif result.category_required?
        render json: { status: 'category_required' }, status: :not_found
      else
        render json: { errors: result.errors }, status: :unprocessable_entity
      end
    end
  end

  private

  def set_user
    # For `create`, we find or create the user. For `index`, we only find.
    @user = if action_name == 'create'
              User.find_or_create_by!(telegram_id: params[:telegram_id])
            else
              User.find_by(telegram_id: params[:telegram_id])
            end

    # If user isn't found for index, render a clear error.
    render json: { error: 'User not found' }, status: :not_found unless @user
  end

  def transaction_params
    params.require(:transaction).permit(
      :description,
      :amount,
      :transaction_type,
      :transaction_date,
      :account_id,
      :category_id # It's okay for this to be nil initially
    )
  end
end
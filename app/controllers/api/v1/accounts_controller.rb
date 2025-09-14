# app/controllers/api/v1/accounts_controller.rb

class Api::V1::AccountsController < ApplicationController
  # This controller handles creating and listing financial accounts (e.g., Checking, Savings).

  # GET /api/v1/accounts
  # Fetches all accounts for a given user.
  # The bot must provide the telegram_id as a query parameter.
  # Example: GET /api/v1/accounts?telegram_id=12345
  def index
    user = User.find_by(telegram_id: params[:telegram_id])

    if user
      accounts = user.accounts
      render json: accounts, status: :ok
    else
      # If the user doesn't exist, they have no accounts. Return an empty array.
      render json: [], status: :ok
    end
  end

  # POST /api/v1/accounts
  # Creates a new account for a user.
  # The bot must send telegram_id and account data in the JSON body.
  def create
    # Find the user by the ID the bot sent. If they don't exist, create them.
    user = User.find_or_create_by(telegram_id: params[:telegram_id])
    # Build the account belonging to that specific user.
    account = user.accounts.build(account_params)

    if account.save
      render json: account, status: :created
    else
      render json: { errors: account.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  # Strong Parameters for security.
  # This whitelists the attributes that can be mass-assigned.
  def account_params
    params.require(:account).permit(:name, :account_type, :balance)
  end
end
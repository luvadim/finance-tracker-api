class Api::V1::UsersController < ApplicationController
  def set_current_account
    user = User.find_by(telegram_id: params[:telegram_user_id])
    account = user&.accounts&.find_by(id: params[:account_id])

    if user && account
      user.update(current_account_id: account.id)
      render json: { message: "Current account updated.", current_account_id: user.current_account_id }, status: :ok
    else
      render json: { error: "User or account not found." }, status: :not_found
    end
  end

  def index
    user = User.find_by(telegram_id: params[:telegram_id])
    if user
      render json: user, status: :ok
    else
      render json: { error: "User not found." }, status: :not_found
    end
  end

  private

  # Strong Parameters for security.
  # This whitelists the attributes that can be mass-assigned.
  def user_params
    params.require(:user).permit(:account_id, :telegram_id)
  end
end
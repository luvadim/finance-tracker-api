class ApplicationController < ActionController::API
  before_action :authenticate_bot

  private

  def authenticate_bot
    secret_key = Rails.application.credentials.bot_api_key

    unless request.headers['Authorization']&.split(' ')&.last == secret_key
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
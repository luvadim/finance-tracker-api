class Api::V1::PlannedTransactionsController < Api::V1::BaseController
  before_action :set_planned_transaction, only: [:show, :update, :destroy]

  # GET /api/v1/planned_transactions
  def index
    @planned_transactions = current_user.planned_transactions.order(:planned_date)
    render json: @planned_transactions
  end

  # GET /api/v1/planned_transactions/:id
  def show
    render json: @planned_transaction
  end

  # POST /api/v1/planned_transactions
  def create
    @planned_transaction = current_user.planned_transactions.build(planned_transaction_params)

    if @planned_transaction.save
      render json: @planned_transaction, status: :created
    else
      render json: { errors: @planned_transaction.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/planned_transactions/:id
  def update
    if @planned_transaction.update(planned_transaction_params)
      render json: @planned_transaction
    else
      render json: { errors: @planned_transaction.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/planned_transactions/:id
  def destroy
    @planned_transaction.destroy
    head :no_content
  end

  private

  def set_planned_transaction
    @planned_transaction = current_user.planned_transactions.find(params[:id])
  end

  def planned_transaction_params
    params.require(:planned_transaction).permit(
      :description,
      :amount,
      :planned_date,
      :recurrence,
      :account_id,
      :category_id
    )
  end
end
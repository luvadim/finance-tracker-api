class PlannedTransaction < ApplicationRecord
  RECURRENCE_OPTIONS = ['none', 'daily', 'weekly', 'monthly', 'yearly'].freeze
  belongs_to :user
  belongs_to :account
  belongs_to :category

  validates :recurrence, inclusion: { in: RECURRENCE_OPTIONS }
  validates :description, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :planned_date, presence: true
end

# == Schema Information
#
# Table name: planned_transactions
#
#  id           :bigint           not null, primary key
#  amount       :decimal(, )
#  description  :string
#  planned_date :date
#  recurrence   :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  account_id   :bigint           not null
#  category_id  :bigint           not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_planned_transactions_on_account_id   (account_id)
#  index_planned_transactions_on_category_id  (category_id)
#  index_planned_transactions_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (user_id => users.id)
#

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

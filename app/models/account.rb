class Account < ApplicationRecord
  belongs_to :user
  has_many :transactions, dependent: :destroy

  after_create :set_as_current_account, if: :first_account?

  validates :name, presence: true
  validates :account_type, presence: true
  validates :balance, numericality: { greater_than_or_equal_to: 0 }

  private

  def first_account?
    user.accounts.count == 1
  end

  def set_as_current_account
    user.update(current_account_id: id)
  end
end
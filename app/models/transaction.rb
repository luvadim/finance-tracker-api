class Transaction < ApplicationRecord
  belongs_to :account
  belongs_to :category
  belongs_to :user

  after_create :update_account_balance
  after_destroy :revert_account_balance
  validates :amount, numericality: { greater_than: 0 }
  validates :transaction_type, inclusion: { in: %w[income expense] }

  private

  def update_account_balance
    if transaction_type == 'income'
      account.increment!(:balance, amount)
    elsif transaction_type == 'expense'
      account.decrement!(:balance, amount)
    end
  end

  def revert_account_balance
    if transaction_type == 'income'
      account.decrement!(:balance, amount)
    elsif transaction_type == 'expense'
      account.increment!(:balance, amount)
    end
  end
end

# == Schema Information
#
# Table name: transactions
#
#  id               :bigint           not null, primary key
#  amount           :decimal(, )
#  description      :string
#  transaction_date :date
#  transaction_type :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  account_id       :bigint           not null
#  category_id      :bigint           not null
#  user_id          :bigint           not null
#
# Indexes
#
#  index_transactions_on_account_id   (account_id)
#  index_transactions_on_category_id  (category_id)
#  index_transactions_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (user_id => users.id)
#

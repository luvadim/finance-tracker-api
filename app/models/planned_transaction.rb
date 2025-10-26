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

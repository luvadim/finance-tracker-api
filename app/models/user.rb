class User < ApplicationRecord
  has_many :accounts, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :transactions, dependent: :destroy
  has_many :planned_transactions, dependent: :destroy
  has_many :products, dependent: :destroy
end

# == Schema Information
#
# Table name: users
#
#  id                 :bigint           not null, primary key
#  name               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  current_account_id :bigint
#  telegram_id        :string
#
# Indexes
#
#  index_users_on_current_account_id  (current_account_id)
#  index_users_on_telegram_id         (telegram_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (current_account_id => accounts.id)
#

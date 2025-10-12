class Account < ApplicationRecord
  belongs_to :user
  has_many :transactions, dependent: :destroy
  has_many :planned_transactions, dependent: :destroy
  
  before_save :check_duplicates
  after_save :set_default_balance, if: :new_record?
  after_create :set_as_current_account, if: :first_account?

  validates :name, presence: true
  validates :account_type, presence: true
  validates :balance, numericality: { greater_than_or_equal_to: 0 }

  private

 # Prevent duplicate accounts with the same name and type for the user
  def check_duplicates
    if user.accounts.where(name: name, account_type: account_type).where.not(id: id).exists?
      throw(:abort)
    end
  end

  def set_default_balance
    self.balance ||= 0
  end

  def first_account?
    user.accounts.count == 1
  end

  def set_as_current_account
    user.update(current_account_id: id)
  end
end

# == Schema Information
#
# Table name: accounts
#
#  id           :bigint           not null, primary key
#  account_type :string
#  balance      :decimal(, )
#  name         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_accounts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

class Category < ApplicationRecord
  belongs_to :user
  has_many :transactions, dependent: :destroy
  has_many :products, dependent: :destroy

  validates :category_type, inclusion: { in: %w[income expense] }
end

# == Schema Information
#
# Table name: categories
#
#  id            :bigint           not null, primary key
#  category_type :string
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_categories_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

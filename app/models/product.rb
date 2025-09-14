class Product < ApplicationRecord
  belongs_to :user
  belongs_to :category
end

# == Schema Information
#
# Table name: products
#
#  id          :bigint           not null, primary key
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :bigint           not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_products_on_category_id       (category_id)
#  index_products_on_name_and_user_id  (name,user_id) UNIQUE
#  index_products_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (user_id => users.id)
#

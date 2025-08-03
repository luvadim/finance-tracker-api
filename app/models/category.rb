class Category < ApplicationRecord
  belongs_to :user
  has_many :transactions, dependent: :destroy
  has_many :products, dependent: :destroy
end
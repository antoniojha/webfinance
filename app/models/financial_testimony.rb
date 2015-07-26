class FinancialTestimony < ActiveRecord::Base
  belongs_to :user
  belongs_to :product
  validates :title, :financial_category,:product_id,:description,:user_id, presence:true
  has_many :micro_comments, dependent: :destroy
  has_many :activities, as: :trackable, dependent: :destroy
end

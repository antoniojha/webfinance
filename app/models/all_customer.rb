class AllCustomer < ActiveRecord::Base
  belongs_to :customer, polymorphic:true
  has_many :private_messages, dependent: :destroy

  validates :customer_id, uniqueness: { scope: :customer_type}
end

class AccountItem < ActiveRecord::Base
  belongs_to :account
  has_many :spendings
end

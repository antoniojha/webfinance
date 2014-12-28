class Background < ActiveRecord::Base
  has_many :savings, dependent: :destroy 
  has_many :goals, dependent: :destroy 
  has_many :suggested_goals, dependent: :destroy 
  has_many :debts, dependent: :destroy  
  has_many :incomes, dependent: :destroy
  has_many :optional_expenses, dependent: :destroy  
  has_many :fixed_expenses, dependent: :destroy 
  accepts_nested_attributes_for :incomes, :reject_if=> lambda {|a| a[:description].blank?}  
  accepts_nested_attributes_for :savings, :debts,:optional_expenses,:fixed_expenses
  def dob_string
    dob.strftime('%m/%d/%Y') unless dob.blank?
  end
  def dob_string=(dob_str)
    self.dob=Chronic.parse(dob_str)
  end
end

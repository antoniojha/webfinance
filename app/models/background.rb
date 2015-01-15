class Background < ActiveRecord::Base
  has_many :savings, dependent: :destroy 
  has_many :goals, dependent: :destroy 
  has_many :suggested_goals, dependent: :destroy 
  has_many :debts, dependent: :destroy  
  has_many :incomes, dependent: :destroy
  has_many :optional_expenses, dependent: :destroy  
  has_many :fixed_expenses, dependent: :destroy 
  has_many :propertees, dependent: :destroy
  before_save :current_field
  accepts_nested_attributes_for :incomes, :allow_destroy => true, reject_if: :all_blank  
  accepts_nested_attributes_for :fixed_expenses, :allow_destroy => true, reject_if: :all_blank
  accepts_nested_attributes_for :optional_expenses, :allow_destroy => true, reject_if: :all_blank    
  accepts_nested_attributes_for :savings, :allow_destroy => true, reject_if: :all_blank  
  accepts_nested_attributes_for :propertees, :allow_destroy => true, reject_if: :all_blank  
  accepts_nested_attributes_for :debts, :allow_destroy => true, reject_if: :all_blank  

  validates :dob_string, :children, :state, presence: true
  validates :married, :inclusion => {:in => [true, false]}
  validates_associated :savings
  validate :dob_before_today
  def dob_string
    dob.strftime('%m/%d/%Y') unless dob.blank?
  end
  def dob_string=(dob_str)
    self.dob=Chronic.parse(dob_str)
  end
  def dob_before_today
    if dob && dob > Time.zone.today
      errors.add(:dob, "date of birth can't be in the future")
    end
  end
  def current_field
    unless self.current_step
      self.current_step=steps.first
    end
    current_step
  end
  def current_instruction_field
    form_instruction_fields[steps.index(current_field)]
  end
  def next_step
    unless (steps.index(current_step)==(steps.size-1))
      self.current_step=steps[steps.index(current_field)+1]
    end
  end
  def prev_step
    unless (steps.index(current_step)==0)
      self.current_step=steps[steps.index(current_field)-1]
    end
  end
  def steps
    %w[background_1 income_2 fixed_expense_3 optional_expense_4 saving_5 propertee_6 debt_7]
  end
    
  def form_instruction_fields
    %w[instruction_1 instruction_2 instruction_3 instruction_4 instruction_5 instruction_6 instruction_7]
  end
end

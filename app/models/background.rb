class Background < ActiveRecord::Base
  belongs_to :user
  has_many :savings, dependent: :destroy 
  has_many :goals, dependent: :destroy 
  has_many :suggested_goals, dependent: :destroy 
  has_many :debts, dependent: :destroy  
  has_many :incomes, dependent: :destroy
  has_many :optional_expenses, dependent: :destroy  
  has_many :fixed_expenses, dependent: :destroy 
  has_many :propertees, dependent: :destroy
  has_many :protection_plans, dependent: :destroy
  
  before_save :current_field
  
  accepts_nested_attributes_for :incomes, :allow_destroy => true, reject_if: :all_blank  
  accepts_nested_attributes_for :fixed_expenses, :allow_destroy => true, reject_if: :all_blank
  accepts_nested_attributes_for :optional_expenses, :allow_destroy => true, reject_if: :all_blank    
  accepts_nested_attributes_for :savings, :allow_destroy => true, reject_if: :all_blank  
  accepts_nested_attributes_for :propertees, :allow_destroy => true, reject_if: :all_blank  
  accepts_nested_attributes_for :debts, :allow_destroy => true, reject_if: :all_blank  

  validates :dob_string, :children, :state, :year,:month, presence: true
  validates :married, :inclusion => {:in => [true, false]}

  validate :dob_before_today
  validates :month, uniqueness: {scope:[:user_id, :year],message:"Plan for this month has been created already"}
  def self.nav_links 
    ["1. Background", "2. Income","3. Fixed Expense","4. Optional Expense","5. Saving","6. Property","7. Debt"]
  end
  def sum_attributes

    
    array1,array2,array3,array4,array5=[[],[],[],[],[]]
    self.incomes.each{|t| array1 << t.amount}
    income_total=array1.sum   
    self.total_income= (income_total==nil) ? 0 : income_total
   
    self.savings.each{|t| array2 << t.amount}
    saving_total=array2.sum
    self.total_saving= (saving_total==nil) ? 0 : saving_total

    self.debts.each{|t| array3 << t.amount}
    debt_total=array3.sum
    self.total_debt= (debt_total==nil) ? 0 : debt_total
    
    self.optional_expenses.each{|t| array4 << t.amount}
    opt_expense_total=array4.sum
    self.total_optional_expense= (opt_expense_total==nil) ? 0 : opt_expense_total 
    
    self.fixed_expenses.each{|t| array5 << t.amount}
    fix_expense_total=array5.sum
    self.total_fixed_expense= (fix_expense_total==nil) ? 0 : fix_expense_total  
    
    self.netspend=income_total-fix_expense_total-opt_expense_total
    self.networth=saving_total-debt_total
    
  end
  def calc_protection_need
    array1,array2,array3=[[],[],[]]
    self.debts.each{|t| 
      if t.cat_name=="Mortgage Loan"
        array1 << t.amount
      end  
    }
    self.total_mortgage=array1.sum

    self.debts.each{|t| 
      if t.cat_name!="Mortgage Loan"
        array2 << t.amount
      end
    }
    self.other_debt=array2.sum
    
    self.incomes.each{|t|
      if t.cat_name=="Pay Check"
        array3 << t.amount
      end   
    }
    self.income_need=(array3.sum)*10*12
    
    self.total_protection_need=array1.sum+array2.sum+array3.sum*10*12
  end

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
  def current_step_int
    steps.index(current_field)
    
  end
  def current_instruction_field
    form_instruction_fields[steps.index(current_field)]
  end
  def next_step
    unless (steps.index(current_step)==(steps.size-1))
      self.current_step=steps[steps.index(current_field)+1]
    else
      self.current_step=steps[-1]
    end
  end
  def prev_step
    unless (steps.index(current_step)==0)
      self.current_step=steps[steps.index(current_field)-1]
    else
      self.current_step=steps[steps.size-1]
    end
  end
  def skip_to_step(i)
    i=i.to_i%7-1
    self.current_step=steps[i]
  end
  def is_complete
    self.completed=true
  end
  def steps
    %w[background_1 income_2 fixed_expense_3 optional_expense_4 saving_5 propertee_6 debt_7]
  end
    
  def form_instruction_fields
    %w[instruction_1 instruction_2 instruction_3 instruction_4 instruction_5 instruction_6 instruction_7]
  end
end

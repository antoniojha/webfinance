class Order <ActiveRecord::Base
  EXPENSE_TYPES=[["Food Expense",1],["Finance Expense",2],["Shopping Expense",3],["Transportation Expense",4],["Entertainment Expense",5],["Other Expense",6]]
  SAVING_TYPES=[["Cash and Cash Equivalent",1],["Checking Account",2],["Saving Account",3],["Annuities",4],["Bonds",5],["Life Insurance (Cash Value)",6],["Mutual Fund",6], ["Pension",7],["Stocks",8],["Retirement Plan",9],["Other",10]]
  INCOME_TYPES=[["Pay Check",1],["Rental Income",2],["Gov Benefit",3],["Investment Income",4],["Interest Income",5], ["Tax Return",6]]
  FIXED_EXPENSE_TYPES=[["Insurance",1],["Loan",2],["Utility",3],["Services",4], ["Rental",5],["Credit Card Payment",6],["Investment",7],["Other",8]]
  PROPERTY_TYPES=[["Real Estate",1],["Vehicle",2],["Other Personal Property",3]]
  DEBT_TYPES=[["Student Loan",1],["Mortgage Loan",2],["Other Loan",3],["Credit Card",4]]
  PLAN_TYPES=[["Protection Plan",1],["Debt Management",2],["Emergency Fund",3],["Retirement Plan",4],["Education Fund",5],["Saving up",6]]
  PROTECTION_TYPES=[["Life Insurance",1],["Disability Insurnace",2]]
  US_STATES=
    [
      ['Alabama', 'AL'],
      ['Alaska', 'AK'],
      ['Arizona', 'AZ'],
      ['Arkansas', 'AR'],
      ['California', 'CA'],
      ['Colorado', 'CO'],
      ['Connecticut', 'CT'],
      ['Delaware', 'DE'],
      ['District of Columbia', 'DC'],
      ['Florida', 'FL'],
      ['Georgia', 'GA'],
      ['Hawaii', 'HI'],
      ['Idaho', 'ID'],
      ['Illinois', 'IL'],
      ['Indiana', 'IN'],
      ['Iowa', 'IA'],
      ['Kansas', 'KS'],
      ['Kentucky', 'KY'],
      ['Louisiana', 'LA'],
      ['Maine', 'ME'],
      ['Maryland', 'MD'],
      ['Massachusetts', 'MA'],
      ['Michigan', 'MI'],
      ['Minnesota', 'MN'],
      ['Mississippi', 'MS'],
      ['Missouri', 'MO'],
      ['Montana', 'MT'],
      ['Nebraska', 'NE'],
      ['Nevada', 'NV'],
      ['New Hampshire', 'NH'],
      ['New Jersey', 'NJ'],
      ['New Mexico', 'NM'],
      ['New York', 'NY'],
      ['North Carolina', 'NC'],
      ['North Dakota', 'ND'],
      ['Ohio', 'OH'],
      ['Oklahoma', 'OK'],
      ['Oregon', 'OR'],
      ['Pennsylvania', 'PA'],
      ['Puerto Rico', 'PR'],
      ['Rhode Island', 'RI'],
      ['South Carolina', 'SC'],
      ['South Dakota', 'SD'],
      ['Tennessee', 'TN'],
      ['Texas', 'TX'],
      ['Utah', 'UT'],
      ['Vermont', 'VT'],
      ['Virginia', 'VA'],
      ['Washington', 'WA'],
      ['West Virginia', 'WV'],
      ['Wisconsin', 'WI'],
      ['Wyoming', 'WY']
    ]
  def self.return_fixed_expense(background,category)
    objs=background.fixed_expenses
    desc=cat_id=[]
    if category=="debt"
      cat_id=[2,6]
    elsif (category=="saving")
      cat_id=[7]
    elsif (category=="propertee")
      cat_id=[1]
    end
    objs.each do |o|
      if cat_id.include?(o.category)
        desc<<o.description
      end
    end
    index=Array(1..(desc.count))  
    return [desc,index].transpose
  end
end
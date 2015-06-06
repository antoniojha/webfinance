class Order <ActiveRecord::Base
  EXPENSE_TYPES=[["Food Expense",1],["Finance Expense",2],["Shopping Expense",3],["Transportation Expense",4],["Entertainment Expense",5],["Other Expense",6]]
  SAVING_TYPES=[["Cash and Cash Equivalent",1],["Checking Account",2],["Saving Account",3],["Annuities",4],["Bonds",5],["Life Insurance (Cash Value)",6],["Mutual Fund",6], ["Pension",7],["Stocks",8],["Retirement Plan",9],["Other",10]]
  INCOME_TYPES=[["Pay Check",1],["Rental Income",2],["Gov Benefit",3],["Investment Income",4],["Interest Income",5], ["Tax Return",6]]
  FIXED_EXPENSE_TYPES=[["Insurance",1],["Loan",2],["Utility",3],["Services",4], ["Rental",5],["Credit Card Payment",6],["Investment",7],["Other",8]]
  PROPERTY_TYPES=[["Real Estate",1],["Vehicle",2],["Other Personal Property",3]]
  DEBT_TYPES=[["Student Loan",1],["Mortgage Loan",2],["Other Loan",3],["Credit Card",4]]
  PLAN_TYPES=[["Protection Plan",1],["Debt Management",2],["Emergency Fund",3],["Retirement Plan",4],["Education Fund",5],["Saving up",6]]
  FINANCIAL_CATEGORIES=[["Protection",1],["Debt Management",2],["Retirement",3],["Investment",4],["Education Fund",5],["Budgeting",6],["Tax Saving",7]]
  FINANCIAL_CATEGORIES_HASH={"1"=>"Protection","2"=>"Debt Management","3"=>"Retirement","4"=>"Investment","5"=>"Education Fund","6"=>"Budgeting","7"=>"Tax Saving"}  
  PROTECTION_TYPES=[["Life Insurance",1],["Disability Insurnace",2]]
  RISKS=[["NA"],["Low"],["Medium"],["High"],["Low to unknown"],["Medium to unknown"],["Low to medium"],["Medium to high"]]
  LICENSE_TYPES=[["Life Insurance License",1],["Health Insurance License",2],["Series 3",3],["Series 6",4],["Series 7",5], ["Series 65",6]]
  #license information source http://www.investopedia.com/articles/financialcareers/07/securities_licenses.asp
  LICENSE_DESCRIPTION_HASH={
    "Life Insurance License"=>"It's required to sell all life insurance products",
    "Health Insurance License"=>"It's required to sell all health insurance products",
    "Series 3"=>"It's required to sell commodity future contracts, which are considered the riskiest investment vehicle",
    "Series 6"=>"Also known as limited-investment securities license. It allows to sell mutual funds, variable annuities and unit investment trusts (UITs)",
    "Series 7"=>"Also known as general securities representative (GS) license. It allows to sell all kinds of investment vehicle except for packaged products that required life insurance, commodity future contracts, and real estate",
    "Series 65"=>"It's required for anyone who provides non-commission financial advice service"
    }
  
  #based on http://www.investopedia.com/articles/financialcareers/07/securities_licenses.asp
  LICENSE_TYPES_HASH={"1"=>"Life Insurance Agent","2"=>"Health Insurance Agent","3"=>"Series 6","4"=>"Series 7"}
  LENGTH_UNITS=[["mile",1],["kilometer",2]]
  INCOME_LEVELS=[["0 to $30,000",1],["$30,000 to $70,000",2],["$70,000 and above",3]]
  AGE_LEVELS=[["20-39 years old", "young generation"],["40-59 years old","middle generation"],["60 years old and up","late generation"]]
  
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
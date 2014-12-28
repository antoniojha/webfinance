class Order <ActiveRecord::Base
  EXPENSE_TYPES=[["Food Expense",1],["Finance Expense",2],["Shopping Expense",3],["Auto Expense",4],["Entertainment Expense",5],["Other Expense",6]]
  SAVING_TYPES=[["No Purpose",1],["Emergency Fund",2],["Retirement Fund",3],["Education Fund",4], ["Othere Purpose",5]]
  INCOME_TYPES=[["Pay Check",1],["Rental Income",2],["Gov Benefit",3],["Investment Income",4],["Interest Income",5]]
  FIXED_EXPENSE_TYPES=[["Insurance",1],["Loan",2],["Utility",3],["Services",4], ["Rental",5]]
end
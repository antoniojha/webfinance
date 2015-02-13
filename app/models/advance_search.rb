class AdvanceSearch < ActiveRecord::Base
  def transactions
    @transactions||=find_transactions
  end
  # Start Date getter
  def start_date_string
    start_date.strftime("%m/%d/%Y") unless start_date.blank?
  end
  #setter
  def start_date_string=(start_date_str)
    self.start_date=Chronic.parse(start_date_str)
  end
  # End Date
  def end_date_string
    end_date.strftime("%m/%d/%Y") unless end_date.blank?
  end
  def end_date_string=(end_date_str)
    self.end_date=Chronic.parse(end_date_str)
  end
  def validate
    errors.add(:start_date, "is invalid") if @start_date_invalid
    errors.add(:end_date,"is invalid") if @end_date_invalid
  end
  ####
  private
  def find_transactions
    Spending.where(conditions)
  end
  def keyword_conditions
    ["spendings.description LIKE ?", "%#{keyword}%"] unless keyword.blank?
  end
  def minimum_price_conditions
    ["spendings.amount >= ?", minimum_price] unless minimum_price.blank?
  end
  def maximum_price_conditions
    ["spendings.amount <= ?", maximum_price] unless maximum_price.blank?
  end
  def start_date_conditions
    ["spendings.transaction_date >= ?", start_date] unless start_date.blank?  
  end
  def end_date_conditions
    ["spendings.transaction_date <= ?", end_date] unless end_date.blank?   
  end
  def conditions
    [conditions_clauses.join(' AND '), *conditions_options]
  end

  def conditions_clauses
    conditions_parts.map { |condition| condition.first }
  end

  def conditions_options
    conditions_parts.map { |condition| condition[1..-1] }.flatten
  end

  def conditions_parts
    private_methods(false).grep(/_conditions$/).map { |m| send(m) }.compact
  end
end

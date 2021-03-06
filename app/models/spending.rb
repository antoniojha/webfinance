
class Spending < ActiveRecord::Base
  belongs_to :user
  has_attached_file :picture, :styles => { :small => "150x150>" }
  VALID_DATE_FORMAT=/\A(\d\d|\d)(\/)(\d\d|\d)(\/)(\d\d\d\d|\d\d)\z/
  validates :description, :amount, :category, presence: true
  validates :transaction_date, presence: { message: "can't be blank or invalid" }
  validates_attachment_size :picture,:less_than => 2.megabytes
  validates_attachment_content_type :picture, :content_type=> ["image/jpg", "image/jpeg", "image/png", "image/gif", "image/pjpeg"]
 #round to the second decimal digit  
  before_save{self.amount=amount.round(2)}  
  def transaction_date_string
    transaction_date.strftime("%m/%d/%Y") unless transaction_date.blank?
  end
  def transaction_date_string=(transaction_date_str)
    self.transaction_date=Chronic.parse(transaction_date_str)
  end
  def self.to_csv(options={})
    column_names=%w[transaction_date description amount category]
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |spending|
        csv << spending.attributes.values_at(*column_names)
      end
    end
  end
  def cat_name
    Order::EXPENSE_TYPES[category-1][0] unless category.blank?
  end
end


class Spending < ActiveRecord::Base
  belongs_to :account_item
  has_attached_file :picture, :styles => { :small => "150x150>" }
  VALID_DATE_FORMAT=/\A(\d\d|\d)(\/)(\d\d|\d)(\/)(\d\d\d\d|\d\d)\z/
  validates :description, :amount, :category, presence: true
  validates :transaction_date, presence: { message: "can't be blank or invalid" }
  validates_attachment_size :picture,:less_than => 2.megabytes
  validates_attachment_content_type :picture, :content_type=> ["image/jpg", "image/jpeg", "image/png", "image/gif", "image/pjpeg"]
 #round to the second decimal digit  
  before_save{self.amount=amount.round(2)}  
  def transaction_date_string
    transaction_date.to_s
  end
  def transaction_date_string=(transaction_date_str)
    self.transaction_date=Chronic.parse(transaction_date_str)
  end

end

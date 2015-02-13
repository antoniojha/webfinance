class Broker < ActiveRecord::Base
  has_many :licenses, dependent: :destroy
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  # the following uses Regex (lookahead assertion) to ensure there is at least a lower case and upper case letter, a digit, and a special character (non-word character)
  VALID_PASSWORD_REGEX= /(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*\W)/
  has_secure_password
  accepts_nested_attributes_for :licenses, :allow_destroy => true
  attr_writer :phone_work_1, :phone_work_2, :phone_work_3, :phone_cell_1, :phone_cell_2, :phone_cell_3
  validates :first_name,:last_name, :institution_name, :street,:city,:state, :email,:license_type, presence: true 
  validates :password_confirmation, presence:true, on: :create
  validates :phone_number_work, presence:true, on: :create
  validates :email, allow_blank:true, format: {with:VALID_EMAIL_REGEX}
  validates :password, allow_blank:true, length: { in: 7..40 }, format:{with:VALID_PASSWORD_REGEX}
  before_validation :save_phone_numbers
  validates :phone_number_work, allow_blank:true, length:{ is: 10 }
  validates :phone_number_cell, allow_blank:true, length:{is:10}
 
  validates_uniqueness_of :username, :case_sensitive => false
  validates_uniqueness_of :email, :case_sensitive => false
  before_save{self.username=username.downcase}
  before_save{self.email=email.downcase}
  before_save{self.first_name=first_name.downcase}
  before_save{self.last_name=last_name.downcase}
  serialize :license_type, Array
  geocoded_by :address
  after_validation :geocode
  def submit
    confirmation_number=generate_confirmation(:confirmation_number_digest)
    update_attribute(:submitted, true)
    update_attribute(:submitted_at, Time.zone.now)
    send_email_confirmation(self, confirmation_number)
    return confirmation_number
  end

  def license_cat_name(category)
    Order::LICENSE_TYPES[category-1][0] unless category.blank?
  end
  def build_licenses
    self.license_type.each do |i|
      license=self.licenses.build
      license.license_type=i
    end
  end
  def address
    [street, city, state, "USA"].compact.join(', ')
  end
  def save_phone_numbers
    self.phone_number_work=[@phone_work_1, @phone_work_2, @phone_work_3].join("")
    self.phone_number_cell=[@phone_cell_1, @phone_cell_2, @phone_cell_3].join("")
  end
  def phone_work_1
    phone_number_work[0..2] unless phone_number_work.blank?
  end
  def phone_work_2
    phone_number_work[3..5] unless phone_number_work.blank?
  end
  def phone_work_3
    phone_number_work[6..9] unless phone_number_work.blank?
  end
  def phone_cell_1
    phone_number_cell[0..2] unless phone_number_cell.blank?
  end
  def phone_cell_2
    phone_number_cell[3..5] unless phone_number_cell.blank?
  end
  def phone_cell_3
    phone_number_cell[6..9] unless phone_number_cell.blank?
  end

  def authenticated?(auth_token)
    return false if confirmation_digest_digest.nil?
    BCrypt::Password.new(confirmation_number_digest).is_password? (auth_token)
  end
  private
  def generate_confirmation(column)
    begin
      random=SecureRandom.random_number(1000000000).to_s
      self[column]=Broker.digest(random)
    end while Broker.exists?(column=>self[column])
    return random
  end
  def Broker.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
    # this method may seem unnecessary but it's to keep things organize as there will be many send_mail methods
  def send_email_confirmation(broker, confirmation_number)
    BrokerNotifier.confirm(broker, confirmation_number).deliver
  end
end

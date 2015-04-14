class Broker < ActiveRecord::Base

  attr_accessor :auth_token,:license_type_edit,:license_type_remove,:custom_validates,:custom_validates2
  
  belongs_to :firm
  has_many :licenses, dependent: :destroy
  has_many :appointments,dependent: :destroy
  has_many :products, through: :appointments
  has_many :application_comment_relations
  has_many :application_comments, through: :application_comment_relations
  has_many :quote_relations
  has_many :users, through: :quote_relations
  has_many :schedules,dependent: :destroy
  has_many :users, through: :schedules
  has_many :broker_backups
  has_many :temp_brokers
  has_many :temp_licenses
  
  has_attached_file :identification
  validates_attachment_presence :identification, on: [:create,:validates_new_id]
  validates_attachment_size :identification, :less_than => 5.megabytes
  validates_attachment :identification, content_type: {content_type: "application/pdf"}
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
  serialize :license_type_edit,Array
  serialize :license_type_remove, Array
  geocoded_by :address
  validate :check_valid_state
  after_validation :geocode, :if => :address_changed?
  
  validate :validates_different_license
  def check_valid_state
    if Order::US_STATES.flatten.include?(state)
      if state.size != 2
        self.state=Order::US_STATES.to_h[state]
      end
    else
      errors.add(:state,"Please enter a valid state")
    end
  end
  def address_changed?
    if self.address =="USA"
      return true
    else
      unless self.address==address
        return true
      else
        return false
      end
    end
  end
  def validates_different_license
    if @custom_validates
      errors.add(:license_number,"a new license number must be entered")
    end
    if @custom_validates2
      errors.add(:picture,"must supply a new license proof")
    end
  end
  def name
    return (first_name.capitalize)+" "+(last_name.capitalize)
  end
  # associate broker with financial product during registering process
  def appoint(product)
    appointments.create(product_id: product.id)
  end
  def unappoint(product)
    appointments.find_by(product.id).destroy
  end
  def appointed_with?(product)
    products.include?(product)
  end
  def accepted
      update_attributes(status:"accepted",approved:true)
  end
  def rejected
      update_attributes(status:"rejected",approved:false)
  end
  
  def submit
      confirmation_number=generate_confirmation(:confirmation_number) # automatically saves the confirmation number
    update_attributes(confirmation_number:confirmation_number,submitted: true,submitted_at: Time.zone.now,status:"pending")
    send_email_confirmation(self, confirmation_number)
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
    if @phone_work_1 && @phone_work_2 && @phone_work_3
      self.phone_number_work=[@phone_work_1, @phone_work_2, @phone_work_3].join("")
      self.phone_number_cell=[@phone_cell_1, @phone_cell_2, @phone_cell_3].join("")
    end
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
  # used to register broker
  def next_step
    unless (steps.index(register_current_step)==(steps.size-1))
      self.register_current_step=steps[steps.index(current_field)+1]
    else
      self.register_current_step=steps[-1]
    end
  end
  def prev_step
    unless (steps.index(register_current_step)==0)
      self.register_current_step=steps[steps.index(current_field)-1]
    else
      self.register_current_step=steps[steps.size-1]
    end
  end
  def current_field
    unless self.register_current_step
      self.register_current_step=steps.first
    end
    register_current_step
  end
  ################
  # used for edit broker
  def next_step_edit
    unless (steps_edit.index(edit_current_step)==(steps_edit.size-1))
      self.edit_current_step=steps[steps_edit.index(current_field_edit)+1]
    else
      self.edit_current_step=steps_edit[-1]
    end
  end
  def prev_step_edit
    unless (steps_edit.index(edit_current_step)==0)
      self.edit_current_step=steps_edit[steps_edit.index(current_field_edit)-1]
    else
      self.edit_current_step=steps[steps_edit.size-1]
    end
  end
  def current_field_edit
    unless self.edit_current_step
      self.edit_current_step=steps_edit.first
    end
    edit_current_step
  end
 ######### 
  def remember
    self.auth_token=SecureRandom.urlsafe_base64
    update_attribute(:auth_token_digest, Broker.digest(auth_token))
  end
  def forget
    update_attribute(:auth_token_digest,nil)
  end
  private
  def generate_confirmation(column)
    begin
      random=SecureRandom.random_number(1000000000).to_s
      self[column]=random
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
    
  def steps
    %w[form1 form2 form3 final_summary4]
  end
  def steps_edit
    %w[form2 form3 form4]
  end
  def steps_edit_other
    %w[form2_other form3_other form4_other]
  end
end

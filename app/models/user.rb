
class User < ActiveRecord::Base
  attr_accessor :auth_token, :password, :password_confirmation, :name_or_email
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  
  attr_writer :phone_1, :phone_2, :phone_3
  # used for password digest to confirm two passwords entered match
 # has_secure_password
  #need to have customized password authentication
  has_attached_file :picture, :styles => { :medium => "200x200#",:large=>"500x500>"},:processors => [:cropper]
  has_many :accounts, dependent: :destroy
  has_many :backgrounds, dependent: :destroy 
  has_many :spendings, dependent: :destroy
  has_many :quote_relations,dependent: :destroy
  has_many :brokers, through: :quote_relations
  has_many :schedules,dependent: :destroy
  has_many :brokers, through: :schedules
#  has_many :temp_budget_plans, dependent: :destroy

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  # the following uses Regex (lookahead assertion) to ensure there is at least a lower case and upper case letter, a digit, and a special character (non-word character)
  VALID_PASSWORD_REGEX= /(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*\W)/

  validates :username, presence: true, on: :create
  validates :password, :password_confirmation, presence: true, on: :create
  validate :check_passwords_match, allow_blank:true, on: :create
  validates :first_name, :last_name,:email,presence: true, on: :update
  validates :email, allow_blank:true, format: {with:VALID_EMAIL_REGEX}
  
  validates :password, allow_blank:true, length: { in: 7..40 },format: {with:VALID_PASSWORD_REGEX}
  validates_uniqueness_of :username, :case_sensitive => false
  validates_uniqueness_of :email, :case_sensitive => false
 # validates_attachment_content_type :picture, :content_type=> ["image/jpg", "image/jpeg", "image/png", "image/gif", "image/pjpeg"]
  #ensure all email address are saved lower case
  def check_passwords_match
    if password !=password_confirmation
      errors.add(:password,"passwords do not match")
    end
  end
  before_save do
    #since in sign up does not register email
    if self.email 
      self.email=email.downcase
    end 
  end
  #ensure all username address are saved lower case
  before_save{self.username=username.downcase}
  before_save :encrypt_password
#  geocoded_by :address
#  validate :check_valid_state, on: [:update]
  
  before_validation :save_phone_number
#  after_validation :geocode, :if => :address_changed?
  after_validation :save_address

  def self.from_omniauth(auth)
    user=where(provider: auth.provider, uid: auth.uid).first_or_initialize do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      if auth["provider"]=="twitter"
        user.username = auth["info"]["nickname"]
        user.first_name=auth["info"]["name"].split.first
        user.last_name=auth["info"]["name"].split.last
      elsif auth["provider"]=="google_oauth2"
        user.email=auth["info"]["email"]
        user.first_name=auth["info"]["first_name"]
        user.last_name=auth["info"]["last_name"]
      elsif auth["provider"]=="facebook"
        user.email=auth["info"]["email"]
        user.first_name=auth["info"]["first_name"]
        user.last_name=auth["info"]["last_name"]     
      end
    end
    user.save(:validate => false)  
    return user
  end
  def check_valid_state
    if Order::US_STATES.flatten.include?(state)
      if state.size != 2
        self.state=Order::US_STATES.to_h[state]
      end
    else
    
      errors.add(:state, "Please enter a valid state")
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
  def address
    [street, city, state, "USA"].compact.join(', ')
  end
  def save_address
    self.address=[street, city, state, "USA"].compact.join(', ')
  end

  def phone_1
    phone_number[0..2] unless phone_number.blank?
  end
  def phone_2
    phone_number[3..5] unless phone_number.blank?
  end
  def phone_3
    phone_number[6..9] unless phone_number.blank?
  end
  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end
  def reprocess_picture
    picture.reprocess!
  end
  def save_phone_number
    if @phone_1 && @phone_2 && @phone_3
      self.phone_number=[@phone_1, @phone_2, @phone_3].join("")
    end
  end
  def picture_geometry(style = :original)
    @geometry ||= {}
    @geometry[style] ||= Paperclip::Geometry.from_file(picture.path(style))
  end
  # associate user with broker for quote request
  def associate_broker(broker, product_type, life_insurance_need)
    quote_relation=quote_relations.create(broker_id: broker.id,product_type:product_type)
    quote_relation.create_quote_requirement(life_insurance_need:life_insurance_need)
    return quote_relation
  end
  def disassociate_broker(quote_relation)
    quote_relations.find_by(id:quote_relation.id).destroy
  end
  def associated_with?(broker,product_type)
    if quote_relations.where(broker_id:broker.id).find_by(product_type:product_type)
      return true
    else
      return false
    end
  end

  def unschedule(broker)
    schedules.find_by(broker.id).destroy
  end
  def schedule_with?(broker)
    if schedules.where(broker_id:broker.id)
      return true
    else
      return false
    end
  end
  def yodlee
    @yodlee ||= Yodlee::User.new(self)
  end
  def send_email_confirmation
    generate_token(:email_confirmation_token)  
    update_attribute(:email_confirmation_sent_at,Time.zone.now)
   #calling save! will render validation error for submitting blank password. Why though? 
   # self.email_confirmation_sent_at=Time.zone.now
   # save!
    
    EmailConfirmationMailer.send_email_confirm(self).deliver
  end
  def set_yodlee_credentials
    if Yodlee::Config.register_users
      self.yodlee_username="user#{id}@your-app-name.com"
      self.yodlee_password=Yodlee::Misc.password_generator
      save!
    end  
  end

    # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  def authenticated?(auth_token)
    return false if auth_token_digest.nil?
    BCrypt::Password.new(auth_token_digest).is_password? (auth_token)
  end
  def remember
    self.auth_token=SecureRandom.urlsafe_base64
    update_attribute(:auth_token_digest, User.digest(auth_token))
  end
  def forget
    update_attribute(:auth_token_digest,nil)
  end
  def has_password?(submitted_password)
    self.password_digest == encrypt(submitted_password)
  end
  private
    def generate_token(column)
      begin
       # update_attribute(column,SecureRandom.urlsafe_base64)
        #saves the user directly instead of just assigning it
        self[column]=SecureRandom.urlsafe_base64
      end while User.exists?(column=>self[column])
    end
    def encrypt_password
      if password
        self.salt = make_salt
        self.password_digest = encrypt(password)
      end
    end

    def encrypt(string)
      secure_hash("#{salt}#{string}")
    end
  
    def make_salt
      secure_hash("#{Time.now.utc}#{password}")
    end
    
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end


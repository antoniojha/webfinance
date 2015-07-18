
class User < ActiveRecord::Base
  attr_accessor :auth_token, :password, :password_confirmation, :name_or_email,:validate_email_bool, :validation_code, :setup_bool, :interest_bool
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  attr_writer :phone_1, :phone_2, :phone_3
  serialize :interests
  has_many :votes, dependent: :destroy
  has_many :accounts, dependent: :destroy
  has_many :backgrounds, dependent: :destroy 
  has_many :spendings, dependent: :destroy
  has_many :quote_relations,dependent: :destroy
  has_many :brokers, through: :quote_relations
  has_many :schedules,dependent: :destroy
  has_many :brokers, through: :schedules
  has_many :goals
#  has_many :temp_budget_plans, dependent: :destroy
  has_attached_file :picture, :styles => { :medium => "200x200#", :large=>"400x400>", :original=>"600x600>"},:processors => [:cropper]
  validates_attachment_content_type :picture, :content_type=> ["image/jpg", "image/jpeg", "image/png", "image/gif", "image/pjpeg"]
  mount_uploader :image, ImageUploader
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  # the following uses Regex (lookahead assertion) to ensure there is at least a lower case and upper case letter, a digit, and a special character (non-word character)
  VALID_PASSWORD_REGEX= /(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*\W)/
  
  validates :username, presence: true, on: :create, if: :password_signup?
 
  validates :password, :password_confirmation, presence: true, on: :create, if: :password_signup?
  def password_signup?
    (provider!=nil) ? false : true
  end
  validate :check_passwords_match, on: :create, if: :password_signup?
  def check_passwords_match
    if password !=password_confirmation
      errors.add(:password,"passwords do not match")
    end
  end
  # if just update the profile with first name and last name it will not require email to be entered.
  validates :first_name, :last_name,presence: true, on: :update, if: :validate_names_bool?
  
  def validate_names_bool?
    if @setup_bool==true
      return false
    else
      @validate_email_bool!=true
    end
    #validate email_bool is set true only when send validation button is clicked   
  end
  validates :first_name, :last_name,presence: true, on: :update, if: :validate_setup_bool?

  validates :email, presence:true, on: :update, if: :validate_email_bool?
  validates :email, presence:true, on: :update, if: :validate_setup_bool?
  def validate_email_bool?
    @validate_email_bool==true
    #validate email_bool is set true during user edit only when send validation button is clicked 
  end  
  def validate_setup_bool?
    @setup_bool==true
    #validate email_bool is set true during initial setup
  end
  validates :income_level, :age_level,:state, :occupation, presence: true, on: :update, if: :setup_bool?
  def setup_bool?
    @setup_bool==true
  end
  validate :check_interest_not_empty, on: :update, if: :interest_bool?
  def interest_bool?
    @interest_bool==true
  end

  def check_interest_not_empty
    self.interests=interests.reject(&:empty?)
    if interests.empty? 
      errors.add(:interests, "Need to select a financial interest")
    end 
  end

  # this prevents the gotcha of not selecting any checkbox for the interest that would send empty value

  validates :email, allow_blank:true, format: {with:VALID_EMAIL_REGEX}, on: :update
  validates :password, allow_blank:true, length: { in: 7..40 }
  validates_uniqueness_of :username, :case_sensitive => false, if: :username?
  # the above validation is working during the sign up even when the form does not asks username to be entered. 
  # so s afunction is written to make sure the validation runs only when email is entered.
  def username?
    (username!=nil) ? true : false
  end  

  validates_uniqueness_of :email, :case_sensitive => false, if: :email?
  # the above validation is working during the sign up even when the form does not asks email to be entered. 
  # so s afunction is written to make sure the validation runs only when email is entered.
  def email?
    (email!=nil) ? true : false
  end
  

  def evaluate_and_reset_email_authen(email)
  # reset email authen if a new email is set
    if email
      unless self.email == email
        self.email_authen=false
      end
    end
  end
  #ensure all username address are saved lower case
  before_save do
    if username
      self.username=username.downcase
    end
  end
  before_save do
    if email
      self.email=email.downcase
    end
  end
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
      elsif auth["provider"]=="linkedin"
        user.username = auth["info"]["nickname"]
        user.first_name=auth["info"]["name"].split.first
        user.last_name=auth["info"]["name"].split.last  
        user.email=auth["info"]["email"]
      end
    end
    return user
  end

  def steps
    %w[basic_info interests]
  end
  def current_field
    unless step
      self.step=steps.first
    end
    step
  end
  def next_step
    unless (steps.index(step)==(steps.size-1))
      self.step=steps[steps.index(current_field)+1]
    else
      self.step=steps[-1]
    end
  end
  def prev_step
    unless (steps.index(step)==0)
      self.step=steps[steps.index(current_field)-1]
    else
      self.step=steps[steps.size-1]
    end
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
    picture_path = (picture.options[:storage] == :s3) ? picture.url(style) : picture.path(style)
    @geometry[style] ||= Paperclip::Geometry.from_file(picture_path)
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
  def send_email_confirmation
    generate_token(:email_confirmation_token)  
    
   #calling save! will render validation error for submitting blank password. Why though? 
    EmailConfirmationMailer.send_email_confirm(self).deliver
    update_attributes(email_confirmation_sent_at:Time.zone.now)
  end
  def send_new_password
    password=generate_new_password
    EmailConfirmationMailer.send_password(self,password).deliver
  end
    # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  #used to authenticate cookie session
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
  def crop_image
    puts "crop image"
    ImageWorker.perform_async(id,key,"crop",crop_x,crop_y,crop_w,crop_h)    
  end

  class ImageWorker
    include Sidekiq::Worker
    
    def perform(id, key,status,crop_x,crop_y,crop_w,crop_h)
      puts "status: #{status}"   
      user = User.find(id)
      if status=="crop"
        user.crop_x=crop_x
        user.crop_y=crop_y
        user.crop_w=crop_w
        user.crop_h=crop_h
      #  broker.image.recreate_versions!
      end
      user.key=key 
      user.remote_image_url = user.image.direct_fog_url(with_path: true)
      user.image_cropped=true
      user.save!
    end
  end
  private
    def generate_new_password
      password=SecureRandom.urlsafe_base64[0..8]
      self.salt = make_salt
      self.password_digest = encrypt(password) 
      return password
    end
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


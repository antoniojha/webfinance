class Broker < ActiveRecord::Base

  attr_accessor :name_or_email, :password, :password_confirmation,:phone_work_1,:phone_work_2,:phone_work_3, :phone_cell_1, :phone_cell_2, :phone_cell_3,:validate_email_bool, :validation_code, :licensetype_bool, :product_names_bool, :story_bool, :term_of_use_bool,:basic_info_bool
  attr_accessor :financial_category,:product_id, :story
  serialize :license_type
  serialize :product_names
  belongs_to :firm
  # broker has the following dependents: SetupBroker=>License, FinancialStory
  has_one :setup_broker, dependent: :destroy

  has_many :financial_stories, dependent: :destroy
  has_many :products, through: :financial_stories
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
  validates :email, allow_blank:true, format: {with:VALID_EMAIL_REGEX}
  validates :password, allow_blank:true, length: { in: 7..40 }, format:{with:VALID_PASSWORD_REGEX}  
  validates_uniqueness_of :username, :case_sensitive => false
  validates_uniqueness_of :email, :case_sensitive => false
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


  validates :first_name, :last_name, :email, :company_name, :company_location, :title, presence:true, on: :update, if: :info_bool?
  def info_bool?
    if @validate_email_bool
      return false
    else
      @basic_info_bool==true
    end
  end
  validate :ensure_email_validated, on: :update, if: :info_bool?
  def ensure_email_validated 
    unless email_authen==true
      errors.add(:email, "Need to validate email")
    end
  end
  validate :check_licensetype_not_empty, on: :update, if: :licensetype_bool?
  def licensetype_bool?
    @licensetype_bool==true
  end

  def check_licensetype_not_empty
    self.license_type=license_type.reject(&:empty?)
    if license_type.empty? 
      errors.add(:licensetype_bool, "Need to select a license")
    end 
  end
  validate :check_product_names_not_empty, on: :update, if: :product_names_bool?
  def product_names_bool?
    @product_names_bool==true
  end

  def check_product_names_not_empty
    self.product_names=product_names.reject(&:empty?)
    if product_names.empty? 
      errors.add(:product_names_bool, "Need to select a Vehicle")
    end 
  end
  before_save :encrypt_password

  validates :ad_statement, allow_blank:true, length: { maximum: 150 }  
  validates :financial_category,:product_id, :story, presence:true, on: :update, if: :story_bool?
  def story_bool?
    @story_bool==true
  end
  after_update do
    #create Financial Story during the application
    if story_bool?
      self.financial_stories.create(product_id:@product_id, financial_category: @financial_category,description: @story)
      
      @story_bool=false # this variable prevents the story object to be saved twice since there is a @broker.next_step and @broker.save following @broker.update(params)
    end
  end
  validates :check_term_of_use, presence:true, on: :update, if: :term_of_use_bool?
  def term_of_use_bool?
    @term_of_use_bool==true
  end



  def self.from_omniauth(auth)
    
    broker=where(provider: auth.provider, uid: auth.uid).first_or_initialize do |broker|
      broker.provider = auth["provider"]
      broker.uid = auth["uid"]
      if auth["provider"]=="twitter"
        broker.username = auth["info"]["nickname"]
        broker.first_name=auth["info"]["name"].split.first
        broker.last_name=auth["info"]["name"].split.last
      elsif auth["provider"]=="google_oauth2"
        broker.email=auth["info"]["email"]
        broker.first_name=auth["info"]["first_name"]
        broker.last_name=auth["info"]["last_name"]
      elsif auth["provider"]=="facebook"
        broker.email=auth["info"]["email"]
        broker.first_name=auth["info"]["first_name"]
        broker.last_name=auth["info"]["last_name"]   
      elsif auth["provider"]=="linkedin"
        broker.username = auth["info"]["nickname"]
        broker.first_name=auth["info"]["name"].split.first
        broker.last_name=auth["info"]["name"].split.last  
        broker.email=auth["info"]["email"]
      end
    end
    return broker
  end 

  def authenticated?(auth_token)
    return false if confirmation_digest_digest.nil?
    BCrypt::Password.new(confirmation_number_digest).is_password? (auth_token)
  end
 
  def remember
    self.auth_token=SecureRandom.urlsafe_base64
    update_attribute(:auth_token_digest, Broker.digest(auth_token))
  end
  def forget
    update_attribute(:auth_token_digest,nil)
  end
  def has_password?(submitted_password)
    self.password_digest == encrypt(submitted_password)
  end
  def address
    [street, city, state, "USA"].compact.join(', ')
  end
  def send_email_confirmation
    generate_token(:email_confirmation_token)  
    
   #calling save! will render validation error for submitting blank password. Why though? 
    EmailConfirmationMailer.send_email_confirm(self).deliver
    update_attributes(email_confirmation_sent_at:Time.zone.now)
  end
  def evaluate_and_reset_email_authen(email)
  # reset email authen if a new email is set
    if email
      unless self.email == email
        self.email_authen=false
      end
    end
  end
  def steps
    %w[basic_info_1 license_2 license_info_3 vehicle_4 statement_5 register_approve_info_6 term_of_use_7]
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
  def add_or_remove_license
    
    @setup_broker=self.setup_broker
    if @setup_broker
      ex_license_types=ex_license_types(@setup_broker)
      # create new license objects to be filled out in user checks a new license type in page 2
      self.license_type.each do |l|
        unless ex_license_types.include?(l)
          @setup_broker.licenses.build(license_type:l)
        end
      end
      #delete existing license object if user unchecks an existing license type in page 2
      ex_license_types.each do |l|
        unless self.license_type.include?(l)
         @setup_broker.licenses.find_by(license_type:l).destroy
        end
      end
    end
  end

  private

  def generate_token(column)
    begin
       # update_attribute(column,SecureRandom.urlsafe_base64)
        #saves the user directly instead of just assigning it
      self[column]=SecureRandom.urlsafe_base64
    end while Broker.exists?(column=>self[column])
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
  def ex_license_types(setup_broker)
    array=[]
    setup_broker.licenses.each do |f|
      array<< f.license_type
    end
    return array
  end
end

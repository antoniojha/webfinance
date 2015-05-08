class Broker < ActiveRecord::Base

  attr_accessor :name_or_email, :password, :password_confirmation,:phone_work_1,:phone_work_2,:phone_work_3, :phone_cell_1, :phone_cell_2, :phone_cell_3,:validate_email_bool, :validation_code
  belongs_to :firm
  has_many :licenses, dependent: :destroy
  has_many :appointments,dependent: :destroy
  has_many :products, through: :appointments
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
  validates :first_name, :last_name,presence: true, on: :update, if: :validate_names_bool?
  def validate_names_bool?
    @validate_email_bool!=true
    #validate email_bool is set true only when send validation button is clicked
  end
  validates :email, presence:true, on: :update, if: :validate_email_bool?
  def validate_email_bool?
    @validate_email_bool==true
    #validate email_bool is set true only when send validation button is clicked
  end  
  before_save :encrypt_password
  def evaluate_and_reset_email_authen(email)
  # reset email authen if a new email is set
    if email
      unless self.email == email
        self.email_authen=false
      end
    end
  end
  def self.from_omniauth(auth)
    
    broker=where(provider: auth.provider, uid: auth.uid).first_or_initialize do |broker|
      broker.provider = auth["provider"]
      broker.uid = auth["uid"]
      if auth["provider"]=="linkedin"
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

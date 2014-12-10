class User < ActiveRecord::Base
  attr_accessor :auth_token
  # used for password digest to confirm two passwords entered match
  has_secure_password
  has_many :accounts, dependent: :destroy
#  has_many :spendings, dependent: :destroy
#  has_many :temp_budget_plans, dependent: :destroy

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  # the following uses Regex (lookahead assertion) to ensure there is at least a lower case and upper case letter,
  # a digit, and a special character (non-word character)
  VALID_PASSWORD_REGEX= /(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*\W)/
  validates :username, presence: true
  validates :email, presence: true, format: {with:VALID_EMAIL_REGEX}
  validates :password, presence: true, length: { in: 7..20 },format: {with:VALID_PASSWORD_REGEX}
  validates_uniqueness_of :username, :case_sensitive => false
  validates_uniqueness_of :email, :case_sensitive => false
  #ensure all email address are saved lower case
  before_save{self.email=email.downcase}
  #ensure all username address are saved lower case
  before_save{self.username=username.downcase}  
  def yodlee
    @yodlee ||= Yodlee::User.new(self)
  end
  def send_email_confirmation
    generate_token(:email_confirmation_token)
    self.email_confirmation_sent_at=Time.zone.now
    save!
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

  private
  def generate_token(column)
    begin
      self[column]=SecureRandom.urlsafe_base64
    end while User.exists?(column=>self[column])
  end

end


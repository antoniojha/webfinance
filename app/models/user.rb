class User < ActiveRecord::Base
  # used for password digest to confirm two passwords entered match
  has_secure_password
  has_many :accounts, dependent: :destroy
#  has_many :spendings, dependent: :destroy
#  has_many :temp_budget_plans, dependent: :destroy
  
  before_create{generate_token(:auth_token)}

  # taken from Michael Hartl's tutorial
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  # the following uses Regex (lookahead assertion) to ensure there is at least a lower case and upper case letter,
  # a digit, and a special character (non-word character) with at least 7 characters
  VALID_PASSWORD_REGEX= /\A^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*\W).{7,}$\z/
  validates :username, presence: true, length:{within:7..50}
  validates :email, presence: true, format: {with:VALID_EMAIL_REGEX}
  validates :password, presence: true, format: {with:VALID_PASSWORD_REGEX}, on: :create
  validates_uniqueness_of :username, :case_sensitive => false
  validates_uniqueness_of :email
  #ensure all email address are saved lower case
  before_save{self.email=email.downcase}
  #ensure all username address are saved lower case
  before_save{self.username=username.downcase}  
  
  def send_email_confirmation
    generate_token(:email_confirmation_token)
    self.email_confirmation_sent_at=Time.zone.now
    save!
    EmailConfirmationMailer.send_email_confirm(self).deliver
  end
  def generate_token(column)
    begin
      self[column]=SecureRandom.urlsafe_base64
    end while User.exists?(column=>self[column])
  end
  def set_yodlee_credentials
    if Yodlee::Config.register_users
      self.yodlee_username="user#{id}@your-app-name.com"
      self.yodlee_password=Yodlee::Misc.password_generator
      save!
    end  
  end
  def yodlee
    @yodlee ||= Yodlee::User.new(self)
  end
  
end


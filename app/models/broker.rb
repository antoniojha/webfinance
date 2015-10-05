class Broker < ActiveRecord::Base

  attr_accessor :name_or_email, :password, :password_confirmation,:validate_email_bool, :validation_code, :licensetype_bool, :products_bool, :story_bool, :term_of_use_bool,:basic_info_bool, :id_image_bool, :licenses_upload_bool, :send_email_validation_bool
  attr_accessor :financial_category,:product_id, :story, :image, :license_info_4_error, :addition_error_msg
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  serialize :license_type #used during setup, this will not be updated after setup all licenses will be accessed via @broker.setup_broker.licenses
  serialize :product_ids

  # broker has the following dependents: SetupBroker=>License, FinancialStory, :Experiences, :Educations
  has_many :votes, dependent: :destroy
  has_many :financial_product_rels, dependent: :destroy
  has_many :financial_products, through: :financial_product_rels
  has_many :broker_requests, dependent: :destroy
  has_one :setup_broker, dependent: :destroy
  has_many :educations, dependent: :destroy
  has_many :experiences, dependent: :destroy
  
  has_many :financial_stories, dependent: :destroy
  accepts_nested_attributes_for :financial_stories
  has_many :broker_product_rels, dependent: :destroy
  has_many :products, through: :broker_product_rels
  has_many :activities, as: :author, dependent: :destroy
  has_one :all_customer, as: :customer, dependent: :destroy
 
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  # the following uses Regex (lookahead assertion) to ensure there is at least a lower case and upper case letter, a digit, and a special character (non-word character)
  VALID_PASSWORD_REGEX= /(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*\W)/
  
  mount_uploader :image, ImageUploader
  
  mount_uploader :id_image, IdImageUploader
  validate :check_all_licenses_uploaded, if: :licenses_uploaded?
  def check_all_licenses_uploaded
    licenses=self.setup_broker.licenses
    license_types=self.license_type
    unless licenses.count == license_types.count
      errors[:license_info_4_error] << "All licenses should be uploaded."
    end
  end
  def licenses_uploaded?
    @licenses_upload_bool == true
  end
  validates_presence_of :id_image, if: :id_image?

  def id_image?
    @id_image_bool == true
  end
  validate :id_image_size_validation
  def id_image_size_validation
    errors[:id_image] << "should be less than 5MB" if id_image.size > 5.megabytes
  end
  validates :username, presence: true, on: :create, if: :password_signup?
  validates :password, :password_confirmation, presence: true, on: :create, if: :password_signup?
  

  validate :check_passwords_match, on: :create, if: :password_signup?
  def check_passwords_match
    if password !=password_confirmation
      errors.add(:addition_error_msg,"Passwords do not match")
    end
  end
  # return true if it's not signed up through provider
  def password_signup?
    
    (provider==nil) ? true : false
  end
  validates :email, allow_blank:true, format: {with:VALID_EMAIL_REGEX}
  validates :password, allow_blank:true, length: { in: 7..40 }, format:{with:VALID_PASSWORD_REGEX}  
  validates_uniqueness_of :username, :case_sensitive => false, if: :username?
  def username?
    (username!=nil) ? true : false
  end  
  validates_uniqueness_of :email, :case_sensitive => false, if: :email?
  def email?
    (email!=nil) ? true : false
  end
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


  validates :first_name, :last_name, :email, :company_name, :company_location, :title, presence:true, on: :update, if: :basic_info_bool?
  validates :email, presence:true, on: :update, if: :send_email_validation?
  def send_email_validation?
    @send_email_validation_bool==true
  end
  def basic_info_bool?
    if @validate_email_bool==true
      #when validating email, will not validate when update Broker
      return false
    else
      @basic_info_bool==true
    end
  end
  def confirm_email?(validation_code)
    if !validation_code.empty? 
      broker=Broker.find_by_email_confirmation_token(validation_code)
      if broker && (broker.id == self.id)
        update_attribute(:email_authen, true)
        success=true
      end
    end
    unless success
      errors[:addition_error_msg]="Validation code does not match! Email failed to validate."
      return false
    else
      return true
    end

  end
  validate :ensure_email_validated, on: :update, if: :basic_info_bool?
  def ensure_email_validated 
    unless email_authen==true
      errors.add(:addition_error_msg, "You need to validate your email.")
    end
  end
  validate :check_licensetype_not_empty, on: :update, if: :licensetype_bool?
  def licensetype_bool?
    @licensetype_bool==true
  end

  def check_licensetype_not_empty
    if license_type
      self.license_type=license_type.reject(&:empty?)
      if license_type.empty? 
        errors.add(:licensetype_bool, "You need to select a license")
      end
    end
  end
  validate :check_products_not_empty, on: :update, if: :products_bool?
  def products_bool?
    @products_bool==true
  end

  def check_products_not_empty
    self.product_ids=product_ids-[""]
    if product_ids.empty?     
      errors.add(:addition_error_msg, "You need to select at lease one vehicle")
    end 
  end
  before_save :encrypt_password

  validates :ad_statement, allow_blank:true, length: { maximum: 150 }  

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
  def send_approval_email #for both approval and disapproval
    EmailNotice.application_approval(self).deliver 
  end
  def send_rejection_email
    EmailNotice.application_rejection(self).deliver 
  end
  def evaluate_and_reset_email_authen(email)
  # reset email authen if a new email is set
    if email
      if self.email == email
        return false
      else
        self.email_authen=false
        return true
      end
    else
      self.email_authen=false
      return true
    end
  end
  def steps
    %w[basic_info_1 id_2 license_3 license_info_4 vehicle_5 statement_6 financial_story_7 term_of_use_8]
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
    #  raise "#{ex_license_types}"
      ex_license_types.each do |l|
        unless self.license_type.include?(l)
         @setup_broker.licenses.find_by(license_type:l).destroy
        end
      end
    end
  end
  #used for cropping pictures => :cropping?, :reprocess_picture, :picture_geometry
  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def picture_geometry(style = :original)
    @geometry ||= {}
    picture_path = (picture.options[:storage] == :s3) ? picture.url(style) : picture.path(style)
    @geometry[style] ||= Paperclip::Geometry.from_file(picture_path)
  end
 # after_save :enqueue_image

  def crop_image
    puts "crop image"
    ImageWorker.perform_async(id,key,"crop",crop_x,crop_y,crop_w,crop_h)
    
  end

  class ImageWorker
    include Sidekiq::Worker
    
    def perform(id, key,status,crop_x,crop_y,crop_w,crop_h)
      puts "status: #{status}"   
      broker = Broker.find(id)
      if status=="crop"
        broker.crop_x=crop_x
        broker.crop_y=crop_y
        broker.crop_w=crop_w
        broker.crop_h=crop_h
      #  broker.image.recreate_versions!
      end
      broker.key=key 
      broker.remote_image_url = broker.image.direct_fog_url(with_path: true)
      broker.image_cropped=true
      broker.save!
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
      if f.license_type
      array<< f.license_type
      end
    end
    return array
  end

end

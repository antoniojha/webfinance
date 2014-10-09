class User < ActiveRecord::Base
  after_create :set_yodlee_credentials
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

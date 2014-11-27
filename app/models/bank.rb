class Bank < ActiveRecord::Base
  class_attribute :id, :content_service_id, :content_service_display_name, :site_id,:site_display_name, :mfa, :home_url, :container 
  def yodlee
    @yodlee ||=Yodlee::Bank.new(self)
  end
  
  def load_from_yml
    YAML.load_file("#{Rails.root}/config/Bank.yml").attributes.each do |b|
      b.each do |key, value|
      self.send("#{key}=", value)
      end
    end
  end
   
end

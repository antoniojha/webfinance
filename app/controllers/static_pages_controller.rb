class StaticPagesController < ApplicationController
  before_action :remember_location_member, only:[:home]
  before_action :authorize_member_login, only: [:home]
  def about
  end

  def contact
    @contact=Contact.new
  end
  def why_richrly
  end
  def announcement
  end
  def faq
  end
  def home
  end
  def broker_background_check
  end
  def broker_registration_criteria
  end
end
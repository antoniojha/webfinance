class StaticPagesController < ApplicationController
  
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
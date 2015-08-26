class StaticPagesController < ApplicationController
  def about
  end

  def contact
    @contact=Contact.new
  end

  def faq
  end
  def home
  end
  def broker_search_criteria
  end
  def broker_registration_criteria
  end
end
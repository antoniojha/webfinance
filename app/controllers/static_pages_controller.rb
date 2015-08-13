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
end
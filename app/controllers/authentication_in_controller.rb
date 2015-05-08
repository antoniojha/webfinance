class AuthenticationInController < ApplicationController
  include AuthenticationInHelper
  def create
    authenticate_create(session[:guest])
  end
  def failure
 
  end
end

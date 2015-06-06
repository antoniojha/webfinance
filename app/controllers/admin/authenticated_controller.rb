class Admin::AuthenticatedController < ApplicationController
   before_action :authorize_admin
#  http_basic_authenticate_with :name => "frodo", :password => "thering"
  
end
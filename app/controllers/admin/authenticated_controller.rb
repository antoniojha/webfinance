class Admin::AuthenticatedController < ApplicationController
  http_basic_authenticate_with :name => "frodo", :password => "thering"
  
end
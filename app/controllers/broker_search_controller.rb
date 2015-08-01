class BrokerSearchController < ApplicationController
  def create
   
    @broker_search = BrokerSearch.new(search_params)
    if @broker_search.save
      redirect_to brokers_url(id:@broker_search)
    else
      render "index", danger: 'Unsuccessful search'
    end 
  end
  def search_params
    params.require(:broker_search).permit(:name, :license_types,:city, :state,:distance_away)
  end
end

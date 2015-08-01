class UserSearchesController < ApplicationController
  def create
   
    @user_search = UserSearch.new(search_params)
    if @user_search.save
      redirect_to users_url(id:@user_search)
    else
      render "index", danger: 'Unsuccessful search'
    end 
  end
  def search_params
    params.require(:user_search).permit(:name, :state)
  end
end

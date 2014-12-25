class AdvanceSearchController < ApplicationController

  def create
    @advance_search = AdvanceSearch.new(advance_search_params)

    respond_to do |format|
      if @advance_search.save
        format.html { redirect_to spendings_url(:id=>@advance_search), notice: 'Advance search was successfully created.'}
      else
        format.html { render action: 'index', danger: 'Unsuccessful search' }
      end
    end
  end
  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def advance_search_params
    params.require(:advance_search).permit(:keyword, :start_date_string, :end_date_string, :minimum_price, :maximum_price, :hidden_value)
  end
end

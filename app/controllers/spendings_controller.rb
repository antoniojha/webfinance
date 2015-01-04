
class SpendingsController < ApplicationController
  helper_method :sort_column, :sort_direction
  skip_before_action :authorize_login, only: [:new,:create,:index,:show]
  before_action :set_spending, only: [:show, :edit, :update, :destroy]

  # GET /spendings
  # GET /spendings.json
  def index
    if params[:id]  # this id parameter is used to pull up AdvanceSearch
      retrieve_search
    else
      @advance_search = AdvanceSearch.new
      @spendings = Spending.all.where(user_id:current_user.id).order(sort_column+" "+sort_direction).paginate(:page => params[:page])
      @export_spendings = Spending.all.where(user_id:current_user.id)
      @page_num=1
      respond_to do |format|
        format.html
        format.csv{send_data @export_spendings.to_csv}
        format.xls
        format.js
      end
    end
  end

  # GET /spendings/1
  # GET /spendings/1.json
  def show
    @prev=Spending.where(user_id:current_user.id).where('id < ?', @spending.id).last
    @next=Spending.where(user_id:current_user.id).where('id > ?', @spending.id).first
  end

  # GET /spendings/new
  def new
    @spending = Spending.new
  end

  # GET /spendings/1/edit
  def edit
  end

  # POST /spendings
  # POST /spendings.json
  def create
    @spending = Spending.new(spending_params)

    respond_to do |format|
      if @spending.save
        format.html { redirect_to @spending, notice: 'Spending was successfully created.' }
        format.json { render action: 'show', status: :created, location: @spending }
      else
        format.html { render action: 'new' }
        format.json { render json: @spending.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /spendings/1
  # PATCH/PUT /spendings/1.json
  def update
    respond_to do |format|
      if @spending.update(spending_params)
        format.html { redirect_to spendings_url, notice: 'Spending was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @spending.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /spendings/1
  # DELETE /spendings/1.json
  def destroy
    @spending.destroy
    respond_to do |format|
      format.html { redirect_to spendings_url }
      format.json { head :no_content }
    end
  end
  def import
    @import_params=%w(id title description price category transaction_date)
    @transaction_import=TransactionImport.new
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_spending
      @spending = Spending.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def spending_params
      params.require(:spending).permit(:transaction_date_string, :description, :amount, :balance, :image_url, :picture, :category, :account_item_id,:user_id)
    end
  def retrieve_search
    @advance_search=AdvanceSearch.find(params[:id])    
    @spendings=@advance_search.transactions.where(:user_id=>session[:user_id]).paginate(page:params[:page])
    if @spendings.count>0
      @start_date=@spendings.last.transaction_date_string
      @end_date=@spendings.first.transaction_date_string
    end
  end
  def sort_column
    Spending.column_names.include?(params[:sort]) ? params[:sort] : "transaction_date"
  end
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
end

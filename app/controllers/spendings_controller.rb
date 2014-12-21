
class SpendingsController < ApplicationController
  skip_before_action :authorize_login, only: [:new,:create,:index,:show]
  before_action :set_spending, only: [:show, :edit, :update, :destroy]

  # GET /spendings
  # GET /spendings.json
  def index
      @spendings = Spending.all.where(user_id:current_user.id).paginate(:page => params[:page])
  #  @spendings=Spending.paginate(user_id:current_user.id)
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_spending
      @spending = Spending.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def spending_params
      params.require(:spending).permit(:transaction_date_string, :description, :amount, :balance, :image_url, :picture, :category, :account_item_id,:user_id)
    end
end

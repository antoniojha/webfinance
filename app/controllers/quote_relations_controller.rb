class QuoteRelationsController < User::AuthenticatedController
  def index
    @type=params[:type].to_i
    @quotes=current_user.quote_relations
  end
  def quote_lists
    
  end
    #create broker-user quote relation if the user clicks the quote request  
  def create
    if params[:quote_request]
      @broker=Broker.find(params[:broker_id])
      @user=User.find(params[:user_id])
      broker_search=BrokerSearch.find(params[:broker_search_id])
      quote_relation=@user.associate_broker(@broker, broker_search.license_types, params[:life_insurance_need])
      # email will be moved to do a periodic mass email #quote_relation.send_email_notification(@broker,@user,broker_search.license_types)
      set_up_for_ajax_display
      respond_to do |format|
        format.html{
          redirect_to brokers_url(id:broker_search.id), notice: "Quote Send to Broker #{@broker.first_name.capitalize} #{@broker.last_name.capitalize}"
        }
        format.js{}
      end
    end
  end
    #destroy broker-user quote relation if the user cancels the quote request
  def destroy
    QuoteRelation.find_by_id(params[:id]).destroy       
    set_up_for_ajax_display
    respond_to do |format|
      format.html{redirect_to brokers_url(id:broker_search.id)}
      format.js{}
    end
  end
  private
  def set_up_for_ajax_display
    @broker_search=BrokerSearch.find(params[:broker_search_id])
    @brokers=@broker_search.brokers
    @brokers=@brokers.paginate(:page => params[:page])  
  end
end

class Admin::ApplicationCommentsController < Admin::AuthenticatedController
  skip_before_action :authorize_login
  before_action :set_broker, only:[:create,:update]
  before_action :set_comment, only:[:edit,:update]
  def edit
    @broker=@comment.brokers.first
  end
  def update
    if @comment.update(application_comment_params)
      redirect_to admin_broker_url(@broker)
    else
      render "edit"
    end
  end
  def create
    
    @comment=ApplicationComment.new(application_comment_params)
    if @comment.save
      if params[:accepted]
        @broker.accepted      
      elsif params[:rejected]
        @broker.rejected        
      end
      @comment.associate_broker(@broker)
      redirect_to admin_brokers_url
    else
      render "admin/brokers/show"
    end
  end
  private
  def set_broker
    @broker=Broker.find(params[:broker_id])
  end
  def set_comment
    @comment=ApplicationComment.find(params[:id])
  end
  def application_comment_params
    params.require(:application_comment).permit(:comment)
  end
end

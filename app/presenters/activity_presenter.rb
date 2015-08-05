class ActivityPresenter
  include ApplicationHelper
  attr_reader :activity
  def initialize(activity,template)
    @activity=activity
    @template=template
  end
  def h
    @template
  end
  def render_activity
   
    h.div_for activity do
      
      h.link_to(full_name(activity.author), activity.author) + " " + render_partial + time + remove_link
    end    
    
  end
  def render_activity_with_pic
    author=activity.author
    h.div_for activity do
      h.raw("<div style='float:left;'>")+h.smart_image(author,4)+h.raw("</div>") + h.raw("<div style='overflow:auto;padding:5px;'>")+h.link_to(full_name(activity.author), activity.author) + " " + render_partial + time+ h.raw("</div>") 
    end    
    
  end
  private
  def time
    h.raw("<br>")+"On "+activity.trackable.created_at.strftime("%-m-%d-%y at %l:%M %P")
  #    " on "+activity.trackable.updated_at.strftime("%m-%d-%y at %l:%M %P UTC")

  end
  def remove_link
    h.raw("<div style='float:right;'>")+h.link_to('remove', {controller:"activities",action:"destroy",id:activity.id},method: :delete,:remote => true)+h.raw("</div>")
  end
  def render_partial
    locals={activity:activity}
    locals[activity.trackable_type.underscore.to_sym] = activity.trackable
    h.render partial_path, locals
  end
  def partial_path
    "activities/#{activity.trackable_type.underscore}"
  end
end
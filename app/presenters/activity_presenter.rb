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
      
      h.link_to(full_name(activity.author), activity.author) + " " + render_partial + time 
    end    
    
  end
  private
  def time
    h.raw("<br>")+activity.trackable.updated_at.strftime("%m-%d-%y at %l:%M %P UTC")
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
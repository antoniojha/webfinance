module ApplicationHelper
  def column_width_right
    if current_controller=='spendings'
      return "col-md-3"
    else
      return "col-md-2"
    end
  end
  def column_width_middle
    if current_controller=='spendings'
      return "col-md-6"
    else
      return "col-md-8"
    end
  end
  def column_width_left
    if current_controller=='spendings'
      return "col-md-3"
    else
      return "col-md-2"
    end
  end

end

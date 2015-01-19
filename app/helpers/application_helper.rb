include ActionView::Helpers::NumberHelper

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
  def asterisk_html
    "<span class='asterisk'>*</span>".html_safe
  end
  def money(amount)
    if amount.is_a? Numeric
      number_to_currency(amount)
    end
  end
end

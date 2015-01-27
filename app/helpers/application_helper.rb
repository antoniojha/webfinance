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
    else
      number_to_currency(0)
    end
  end
  def smart_image(user,scenario=1)
    if user.picture_file_name
      if scenario == 1
        image_tag user.picture.url(:medium),size:"100x100", class: "img-thumbnail"
      elsif scenario ==2
        image_tag user.picture.url(:medium), class: "img-thumbnail"
      end
    else
      image_tag "place_holder.jpg",size:"100x100", class: "img-thumbnail", alt:"Please upload picture"
    end
  end
end

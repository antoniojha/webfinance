include ActionView::Helpers::NumberHelper

module ApplicationHelper
  def column_width_right
    if current_controller=='spendings'
      return "col-md-3"
    elsif current_controller=='brokers' && controller.action_name=="index"
      return "col-md-3"
    else
      return "col-md-2"
    end
  end
  def column_width_middle
    if current_controller=='spendings'
      return "col-md-6"
    elsif current_controller=='brokers' && controller.action_name=="index"
      return "col-md-7"
    else
      return "col-md-8"
    end
  end
  def column_width_left
    if current_controller=='spendings'
      return "col-md-3"
    elsif current_controller=='brokers' && controller.action_name=="index"
      return "col-md-2"  
    else
      return "col-md-2"
    end
  end
  def asterisk_html
    "<span class='asterisk'>*</span>".html_safe
  end
  # applicable to broker and user object
  def cap(name)
    if name.nil?
      name
    else
      name=name.capitalize
    end
  end
  def full_name(person)
    name=person.first_name.capitalize+ " "+person.last_name.capitalize
    return name
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
     #   image_tag user.picture.url(:medium),size:"100x100", class: "img-thumbnail"
      elsif scenario ==2
    #    image_tag user.picture.url(:medium), class: "img-thumbnail"
      end
    else
      if scenario ==3
        image_tag "place_holder.jpg",size:"200x200", class: "img-thumbnail", alt:"Please upload picture"
      else
        image_tag "place_holder.jpg",size:"100x100", class: "img-thumbnail", alt:"Please upload picture"
      end
    end
  end
  def phone_num_display(phone_num)
    if phone_num && phone_num.size==10
      phone_num.insert(6,"-")
      phone_num.insert(3,"-")
    end
    return phone_num
  end
  def date(datetime)
    if datetime
      datetime.strftime('%m/%d/%Y at %I:%M%p')
    end
  end
  def abrev_display(string,length)
    unless string.nil?
      if string.size >length
        string2= string[0..length]+"..."
        return string2
      else
        return string
      end
    end
  end
  def select_tag_array(big_array,select_array)
    array=[]
    select_array.each do |l|
      array<< big_array[l.to_i-1]
      
    end
    array
  end
end

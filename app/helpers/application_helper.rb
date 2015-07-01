include ActionView::Helpers::NumberHelper

module ApplicationHelper
  def column_width_right
    if current_controller=='brokers' && controller.action_name=="index"
      return "col-md-3"
    elsif current_controller=="static_pages"
      return "col-md-1"
    else
      return "col-md-2"
    end
  end
  def column_width_middle
    if current_controller=='brokers' && controller.action_name=="index"
      return "col-md-7"
    elsif current_controller=="static_pages"
      return "col-md-10"
    else
      return "col-md-8"
    end
  end
  def column_width_left

    if current_controller=='brokers' && controller.action_name=="index"
      return "col-md-2"  
    elsif current_controller=="static_pages"
      return "col-md-1"
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
    if person.first_name && person.last_name
    name=person.first_name.capitalize+ " "+person.last_name.capitalize
    return name
    end
  end
  def money(amount)
    if amount.is_a? Numeric
      number_to_currency(amount)
    else
      number_to_currency(0)
    end
  end
  def smart_label(name)
    if name
      name.sub!('_', ' ')
      name=name.titleize
    end
  end
  def smart_image(user,scenario=1)
    
    place_holder_url='http://www.clker.com/cliparts/C/N/O/F/T/X/blank-profile-th.png'
    if !user.image_url.to_s.empty?
      if scenario == 1
       # image_tag user.image_url(:thumb_100).to_s
        image_tag user.image_url(:thumb_200).to_s,size:"100x100", class: "img-thumbnail"
      elsif scenario ==2
      #  image_tag user.image_url(:thumb_200).to_s
        image_tag user.image_url(:thumb_200).to_s,size:"200x200", class: "img-thumbnail"
      elsif scenario ==4
     #   image_tag user.image_url(:thumb_75).to_s
        image_tag user.image_url(:thumb_200).to_s,size:"75x75", class: "img-thumbnail"
      end
    else
      if scenario ==4
        image_tag place_holder_url,size:"75x75", class: "img-thumbnail", alt:"Please upload picture"        
      elsif scenario ==3
        image_tag place_holder_url,size:"300x300", class: "img-thumbnail", alt:"Please upload picture"  
      elsif scenario ==2
        image_tag place_holder_url,size:"200x200", class: "img-thumbnail", alt:"Please upload picture"
      else
        image_tag place_holder_url,size:"100x100", class: "img-thumbnail", alt:"Please upload picture"
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
  def display_time_difference(begin_time,end_time)
    months=((end_time-begin_time).to_f/30).ceil
    if months==0
      months=1
    end
    year=(months.to_f/12).floor
    month=months%12
    
    year_word=pluralize(year,'year')
    month_word=pluralize(month,'month')
    if year==0
      return "(#{month_word})"
    elsif month==0
      return "(#{year_word})"
    else
      return "(#{year_word} #{month_word})"
    end

  end
end

include ActionView::Helpers::NumberHelper

module ApplicationHelper

  def column_width_right 
    controller=params[:controller]
    action=params[:action]
    if (controller=="users" || controller=="brokers")&&(action=="index") || controller=="setup_brokers" || controller=="licenses"
      return "col-md-3"
    elsif (controller=="static_pages" && action=="home")
      return "col-md-1"
    else
      return "col-md-2"
    end
  end
  def column_width_middle
    controller=params[:controller]
    action=params[:action]
    if (controller=="users" || controller=="brokers")&&(action=="index") || controller=="setup_brokers" || controller=="licenses"
      return "col-md-6"
    elsif (controller=="static_pages" && action=="home")
      return "col-md-8"
    else
      return "col-md-8"
    end
  end
  def column_width_left
    controller=params[:controller]
    action=params[:action]
    if (controller=="users" || controller=="brokers")&&(action=="index") || controller=="setup_brokers" || controller=="licenses"
      return "col-md-3"
    elsif (controller=="static_pages" && action=="home")
      return "col-md-3"
    else
      return "col-md-2"
    end
  end
  def user_message_activities(user_owner)
    activities=Activity.where(story_owner_type:"User",story_owner_id:user_owner.id).order(updated_at: :desc).where(trackable_type:"PrivateMessage").first(10)
  end
  def broker_message_activities(broker_owner)
    activities=Activity.where(story_owner_type:"Broker",story_owner_id:broker_owner.id).order(updated_at: :desc).where(trackable_type:"PrivateMessage").first(10)
  end
  def user_activities(user_owner)
    activities=Activity.where(story_owner_type:"User",story_owner_id:user_owner.id).order(updated_at: :desc).where.not(trackable_type:"PrivateMessage").first(10)
  end
  def broker_activities(broker_owner)
    activities=Activity.where(story_owner_type:"Broker",story_owner_id:broker_owner.id).order(updated_at: :desc).where.not(trackable_type:"PrivateMessage").first(10)
  end
  def commented_article(micro_comment)
    if micro_comment.financial_story
      micro_comment.financial_story
    elsif micro_comment.financial_testimony
      micro_comment.financial_testimony
    end
  end
  def trackable_author(trackable)
    if trackable.user
      trackable.user
    elsif trackable.broker
      trackable.broker
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
  def smart_image(member,scenario=1)
    
    place_holder_url='http://www.clker.com/cliparts/C/N/O/F/T/X/blank-profile-th.png'
    if !member.image_url.to_s.empty?
      if scenario == 1
        if member.image.thumb_200.file.exists?
          image_tag member.image_url(:thumb_200).to_s,style: 'width:auto;height:100px;', class: "img-thumbnail"
        else
          image_tag member.image_url.to_s,style: 'width:auto;height:100px;', class: "img-thumbnail"
        end
      elsif scenario ==2
        if member.image.thumb_200.file.exists?
          image_tag member.image_url(:thumb_200).to_s,size:"150x150", class: "img-thumbnail"
        else        
          image_tag member.image_url.to_s,style: 'width:auto;height:150px;', class: "img-thumbnail"
        end
      elsif scenario ==4
        if member.image.thumb_200.file.exists?
          image_tag member.image_url(:thumb_200).to_s,size:"65x65", class: "img-thumbnail"
        else
          image_tag member.image_url.to_s,style: 'width:auto;height:65px;', class: "img-thumbnail"
        end
      end
    else
      if scenario ==4
        image_tag place_holder_url,style: 'width:65px;height:65px;', class: "img-thumbnail", alt:"Please upload picture"        
      elsif scenario ==3
        image_tag place_holder_url,style: 'width:250px;height:250px;', class: "img-thumbnail", alt:"Please upload picture"  
      elsif scenario ==2
        image_tag place_holder_url,style: 'width:150px;height:150px;', class: "img-thumbnail", alt:"Please upload picture"
      else
        image_tag place_holder_url,style: 'width:100px;height:100px;', class: "img-thumbnail", alt:"Please upload picture"
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

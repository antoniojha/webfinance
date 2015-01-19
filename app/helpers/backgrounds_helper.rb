module BackgroundsHelper
  def link_to_field(background,text,field_num)
    if text && field_num
      link_to text, {controller:"backgrounds",action:"edit", id:background,:step=>field_num}
    end
  end
  def start_step_session(background)
    if !session[:last_step_in].nil?
      session[:last_step_in]=1
    end
  end
  def update_step_session(background)
    if !session[:last_step_in].nil?
      session[:last_step_in]=1
    end
    if background.current_step_int > session[:last_step_in]
      session[:last_step_in]=background.current_step_int
    end
  end
  def end_step_session
    session[:last_step_in]=nil
  end
end

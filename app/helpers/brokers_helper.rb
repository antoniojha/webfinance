module BrokersHelper
  
  def forget_temp_broker
    cookies.delete(:temp_broker_id)
  end
  def status_log_in(confirmation_number)
    session[:confirmation_number]=confirmation_number
  end
  def broker_heading(license_type)
    if license_type==1
      heading="All Life License Agents"
    elsif license_type==2
      heading="All Health License Agents"
    end
    return heading
  end
  def quote_relation(user,broker,product_type)
    quote_relation=QuoteRelation.where(user_id:user.id,broker_id:broker.id,product_type:product_type)
    return quote_relation.first
  end
  def quote_button(broker_search,broker)
    type=broker_search.license_types.to_i
    if type==1
      target='#life_insurance_quote'
    elsif type==2
      target="#health_insurance_quote"
    elsif type==3
      target="#life_insurance_quote"
    end
    # the reason button to is not used is because this button will bring up modal form and not submit anything
    "<br><button type='button' class='btn btn-default' data-toggle='modal' data-broker-id=#{broker.id} data-target=#{target}>Request Quote</button>".html_safe
  
  end
end

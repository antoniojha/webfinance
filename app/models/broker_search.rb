class BrokerSearch < ActiveRecord::Base
  def brokers
    @brokers||=find_brokers
  end
  def first_name
    name.split[0]
  end
  def last_name
    name.split[1..-1].join(" ")
  end
  private
  def find_brokers
    puts "condition is #{conditions}..."
    Broker.where(conditions)
    
  end
  # the two name conditions allow user to flip first & last names when doing search
  def name_conditions
    
    ["(brokers.first_name LIKE ? AND brokers.last_name LIKE ?) OR (brokers.first_name LIKE ? AND brokers.last_name LIKE ?)", "%#{first_name}%", "%#{last_name}%", "%#{last_name}%", "%#{first_name}%"] unless name.blank?
  end

  def state_conditions
    ["brokers.state LIKE ?", "%#{state}%"] unless state.blank?
  end  
  def license_type_conditions
   
    ["brokers.license_type LIKE ?", "%#{Order::LICENSE_TYPES_HASH[license_types.to_i]}%"] unless license_types.blank?
  end  
  def conditions
    [conditions_clauses.join(' AND '), *conditions_options]
  end

  def conditions_clauses
    conditions_parts.map { |condition| condition.first }
  end

  def conditions_options
    conditions_parts.map { |condition| condition[1..-1] }.flatten
  end

  def conditions_parts
    private_methods(false).grep(/_conditions$/).map { |m| send(m) }.compact
  end
end

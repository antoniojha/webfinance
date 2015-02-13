class BrokerImport < ActiveRecord::Base
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  attr_accessor :file
  def save
    if imported_brokers.map(&:valid?).all?
      imported_brokers.each do |t|
        t.save
      end
      true
    else
      imported_brokers.each_with_index do |broker,index|
        broker.errors.full_messages.each do |message|
          errors.add :base, "Row #{index+2}:#{message}"
        end
      end
      false
    end
  end
  def imported_brokers
    @imported_brokers||=load_imported_brokers
  end
  def load_imported_brokers
    
    spreadsheet=open_spreadsheet
    header=spreadsheet.row(1)
    (2..spreadsheet.last_row).map do |i|
      row=Hash[[header, spreadsheet.row(i)].transpose]
      broker=Broker.new
      broker.attributes=row.to_hash.slice(*accessible_attributes)
     # errors.add :base, "category is #{transaction.category}"  
      broker
    end
  end
  def open_spreadsheet
    case File.extname(file.original_filename)
    when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
    when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end
  def accessible_attributes
    %w[street city state password password_confirmation]
  end  
end

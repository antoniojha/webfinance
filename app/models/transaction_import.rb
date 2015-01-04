class TransactionImport < ActiveRecord::Base
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  attr_accessor :file
  def save(user_id)
    if imported_transactions.map(&:valid?).all?
      imported_transactions.each do |t|
        t.user_id=user_id
        t.save
      end
      true
    else
      imported_transactions.each_with_index do |transaction,index|
        transaction.errors.full_messages.each do |message|
          errors.add :base, "Row #{index+2}:#{message}"
        end
      end
      false
    end
  end
  def imported_transactions
    @imported_transactions||=load_imported_transactions
  end
  def load_imported_transactions
    
    spreadsheet=open_spreadsheet
    header=spreadsheet.row(1)
    (2..spreadsheet.last_row).map do |i|
      row=Hash[[header, spreadsheet.row(i)].transpose]
      transaction=Spending.find_by_id(row["id"])||Spending.new
      transaction.attributes=row.to_hash.slice(*accessible_attributes)
     # errors.add :base, "category is #{transaction.category}"  
      transaction
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
    %w[description amount category transaction_date]
  end
end
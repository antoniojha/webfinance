class AddColumn6ToLicense < ActiveRecord::Migration
  def change
    add_column :licenses, :expiration_date, :date
  end
end

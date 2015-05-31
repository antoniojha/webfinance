class AddColumn1ToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :current_company, :boolean, defaults: false
  end
end

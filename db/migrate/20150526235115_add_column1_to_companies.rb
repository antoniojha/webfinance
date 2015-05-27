class AddColumn1ToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :name, :string
  end
end

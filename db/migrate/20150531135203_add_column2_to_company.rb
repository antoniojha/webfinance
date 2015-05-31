class AddColumn2ToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :title, :string
  end
end

class RemoveCompanyColumn < ActiveRecord::Migration
  def change
    remove_column :companies, :current_company
  end
end

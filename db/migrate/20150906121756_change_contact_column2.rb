class ChangeContactColumn2 < ActiveRecord::Migration
  def change
    rename_column :contacts, :full_name, :name
  end
end

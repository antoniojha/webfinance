class AddColumnToBackground13 < ActiveRecord::Migration
  def change
    add_column :backgrounds, :gender, :string
  end
end

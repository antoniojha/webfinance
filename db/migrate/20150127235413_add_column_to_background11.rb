class AddColumnToBackground11 < ActiveRecord::Migration
  def change
    add_column :backgrounds, :protection_search, :string
  end
end

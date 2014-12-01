class AddColumnToAccountItem < ActiveRecord::Migration
  def change
    add_column :account_items, :acct_type, :string
    add_column :account_items, :account_number, :integer
  end
end

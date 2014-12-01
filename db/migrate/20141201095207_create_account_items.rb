class CreateAccountItems < ActiveRecord::Migration
  def change
    create_table :account_items do |t|
      t.references :account, index: true
      t.belongs_to :user
      t.integer :item_account_id
      t.string :account_display_name

      t.timestamps
    end
  end
end

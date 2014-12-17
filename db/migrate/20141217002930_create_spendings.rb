class CreateSpendings < ActiveRecord::Migration
  def change
    create_table :spendings do |t|
      t.datetime :transaction_date
      t.text :description
      t.decimal :amount
      t.decimal :balance
      t.string :image_url
      t.string :picture_file_name
      t.string :picture_content_type
      t.integer :picture_file_size
      t.datetime :picture_updated_at
      t.string :category
      t.belongs_to :account_item, index: true

      t.timestamps
    end
  end
end

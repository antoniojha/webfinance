class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.string :endpoint
      t.string :method
      t.text :params
      t.integer :response_code
      t.text :response

      t.timestamps
    end
  end
end

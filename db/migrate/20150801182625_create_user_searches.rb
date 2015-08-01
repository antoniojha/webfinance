class CreateUserSearches < ActiveRecord::Migration
  def change
    create_table :user_searches do |t|
      t.string :name
      t.string :state

      t.timestamps
    end
  end
end

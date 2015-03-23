class CreateApplicationComment < ActiveRecord::Migration
  def change
    create_table :application_comments do |t|
      t.string :comment
    end
  end
end

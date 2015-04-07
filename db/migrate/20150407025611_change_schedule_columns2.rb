class ChangeScheduleColumns2 < ActiveRecord::Migration
  def change
    remove_column :schedules, :user_id
    remove_column :schedules, :broker_id
    add_column :schedules, :user_id, :integer
    add_column :schedules, :broker_id, :integer
  end
end

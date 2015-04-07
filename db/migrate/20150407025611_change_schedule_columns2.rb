class ChangeScheduleColumns2 < ActiveRecord::Migration
  def change
    change_column :schedules, :user_id, :integer
    change_column :schedules, :broker_id, :integer
  end
end

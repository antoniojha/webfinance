class ChangeScheduleColumns < ActiveRecord::Migration
  def change
    change_column :schedules, :user_id, :string
    change_column :schedules, :broker_id, :string
  end
end

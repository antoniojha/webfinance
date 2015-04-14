class ChangeScheduleColumns < ActiveRecord::Migration
  def change
    change_column :schedules, :time_begin, :datetime
    change_column :schedules, :time_end, :datetime
  end
end

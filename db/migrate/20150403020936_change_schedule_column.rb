class ChangeScheduleColumn < ActiveRecord::Migration
  def change
    change_column :schedules, :time_begin, :string
    change_column :schedules, :time_end, :string
  end
end

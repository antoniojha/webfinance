class AddColumnToSchedule2 < ActiveRecord::Migration
  def change
    add_column :schedules, :schedule_date, :date
  end
end

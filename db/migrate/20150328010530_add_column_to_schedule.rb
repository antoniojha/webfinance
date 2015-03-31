class AddColumnToSchedule < ActiveRecord::Migration
  def change
    add_column :schedules, :date, :datetime
  end
end

class AddColumnToSchedule3 < ActiveRecord::Migration
  def change
    add_column :schedules, :time_zone, :string
  end
end

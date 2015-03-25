class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.belongs_to :broker, index: true
      t.belongs_to :user, index: true
      t.datetime :time_begin
      t.datetime :time_end
      t.decimal :duration

      t.timestamps
    end
  end
end

class RenameUserGoalColumn < ActiveRecord::Migration
  def change
    rename_column :users, :goal, :interests
  end
end

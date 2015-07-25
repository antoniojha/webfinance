class ChangeActivityColumn < ActiveRecord::Migration
  def change
    rename_column :activities, :story_owner, :story_owner_type
  end
end

class AddColumn1ToExperience < ActiveRecord::Migration
  def change
    add_column :experiences, :current_experience, :boolean, :default => false
  end
end

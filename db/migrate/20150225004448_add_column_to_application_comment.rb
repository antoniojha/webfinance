class AddColumnToApplicationComment < ActiveRecord::Migration
  def change
    add_column :application_comments, :created_at, :datetime
    add_column :application_comments, :updated_at, :datetime
  end
end

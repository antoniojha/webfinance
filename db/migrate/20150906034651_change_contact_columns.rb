class ChangeContactColumns < ActiveRecord::Migration
  def change
    rename_column :contacts, :title, :subject
    rename_column :contacts, :issue_content, :message
    add_column :contacts, :full_name, :string
  end
end

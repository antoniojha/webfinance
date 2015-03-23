class ChangeApplicationCommentColumn < ActiveRecord::Migration
  def change
    remove_column :application_comments, :comment
    add_column :application_comments, :comment, :text
  end
end

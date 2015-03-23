class CreateApplicationCommentRelations < ActiveRecord::Migration
  def change
    create_table :application_comment_relations do |t|
      t.belongs_to :broker, index: true
      t.belongs_to :application_comment, index: true

      t.timestamps
    end
  end
end

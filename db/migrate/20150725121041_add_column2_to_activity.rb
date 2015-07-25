class AddColumn2ToActivity < ActiveRecord::Migration
  def change
    add_reference :activities, :story_owner, index: true
    add_column :activities, :story_owner, :string
  end
end

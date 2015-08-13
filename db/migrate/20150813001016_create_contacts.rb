class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :title
      t.text :issue_content
      t.string :email

      t.timestamps
    end
  end
end

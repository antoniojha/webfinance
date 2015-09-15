class AddColumn7ToLicense < ActiveRecord::Migration
  def change
    add_column :licenses, :image, :string
  end
end

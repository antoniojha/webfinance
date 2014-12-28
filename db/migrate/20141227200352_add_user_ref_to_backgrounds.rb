class AddUserRefToBackgrounds < ActiveRecord::Migration
  def change
    add_reference :backgrounds, :user, index: true
  end
end

class CreateBrokerBackups < ActiveRecord::Migration
  def change
    create_table :broker_backups do |t|
      t.string :first_name
      t.string :last_name
      t.string :institution_name
      t.string :phone_number_work
      t.string :email
      t.string :phone_number_cell
      t.string :street
      t.string :city
      t.string :state
      t.string :country
      t.belongs_to :firm, index: true
      t.boolean :change_approved?, default:false

      t.timestamps
    end
  end
end

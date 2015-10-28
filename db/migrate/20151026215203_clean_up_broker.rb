class CleanUpBroker < ActiveRecord::Migration
  def change
    remove_column :brokers, :institution_name
    remove_column :brokers, :longitude
    remove_column :brokers, :latitude
    remove_column :brokers, :street
    remove_column :brokers, :city
    remove_column :brokers, :state
    remove_column :brokers, :country
    remove_column :brokers, :approved
    remove_column :brokers, :confirmation_number
    remove_column :brokers, :work_ext
    remove_column :brokers, :firm_id
    remove_column :brokers, :register_current_step
    remove_column :brokers, :status
    remove_column :brokers, :auth_token_digest
    remove_column :brokers, :edit_current_step
    remove_column :brokers, :license_type_edit
    remove_column :brokers, :license_type_remove
    remove_column :brokers, :time_zone
    remove_column :brokers, :aws_image_path
  end
end

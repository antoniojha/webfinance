class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.references :user, index: true
      t.references :bank, index: true
      t.integer :yodlee_id
      t.integer :status_code, :default => 801
      t.datetime :last_refresh
      t.text :last_mfa
      t.timestamps
    end
  end
end

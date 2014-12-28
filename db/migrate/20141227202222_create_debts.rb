class CreateDebts < ActiveRecord::Migration
  def change
    create_table :debts do |t|
      t.string :institution_name
      t.string :description
      t.decimal :amount
      t.decimal :interest_rate
      t.belongs_to :background, index: true

      t.timestamps
    end
  end
end

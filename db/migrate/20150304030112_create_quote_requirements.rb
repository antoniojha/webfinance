class CreateQuoteRequirements < ActiveRecord::Migration
  def change
    create_table :quote_requirements do |t|
      t.decimal :life_insurance_need

      t.timestamps
    end
  end
end

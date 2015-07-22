class CreateFinancialTestimonies < ActiveRecord::Migration
  def change
    create_table :financial_testimonies do |t|
      t.belongs_to :user, index: true
      t.string :financial_category
      t.text :description
      t.integer :votes, default:0

      t.timestamps
    end
  end
end

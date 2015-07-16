class AddColumn1ToGoals < ActiveRecord::Migration
  def change
    add_column :goals, :financial_interests, :string
  end
end

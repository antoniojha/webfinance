class ChangeFinancialStoryColumn < ActiveRecord::Migration
  def change
    rename_column :financial_stories, :vehicle_type, :financial_category
  end
end

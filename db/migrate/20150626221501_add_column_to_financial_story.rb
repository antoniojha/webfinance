class AddColumnToFinancialStory < ActiveRecord::Migration
  def change
    add_column :financial_stories, :title, :string
  end
end

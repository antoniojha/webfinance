class AddColumn2ToMicroComment < ActiveRecord::Migration
  def change
    add_reference :micro_comments, :financial_testimony, index: true
  end
end

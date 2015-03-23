class AddIndexToQuoteRequirement < ActiveRecord::Migration
  def change
    add_reference :quote_requirements, :quote_relation, index: true
  end
end

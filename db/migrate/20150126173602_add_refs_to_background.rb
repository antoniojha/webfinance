class AddRefsToBackground < ActiveRecord::Migration
  def change
    add_reference :protection_plans, :background, index: true
  end
end

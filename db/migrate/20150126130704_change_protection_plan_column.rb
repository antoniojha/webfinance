class ChangeProtectionPlanColumn < ActiveRecord::Migration
  def change
    change_column :protection_plans, :debt, :decimal, default: 0
    change_column :protection_plans, :income, :decimal, default: 0
    change_column :protection_plans, :mortgage,:decimal, default: 0
    change_column :protection_plans, :education,:decimal, default: 0
    change_column :protection_plans, :total_need,:decimal, default: 0
  end
end

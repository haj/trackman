class ChangeParamsColumnTypeInAlarmRulesTable < ActiveRecord::Migration
  def change
  	change_column :alarms_rules, :params, :text
  end
end

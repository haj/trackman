class RenameCurrentToCurrencyInPlans < ActiveRecord::Migration
  def change
  	rename_column :plans, :current, :currency
  end
end

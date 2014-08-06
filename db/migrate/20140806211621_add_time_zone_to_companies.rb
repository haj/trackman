class AddTimeZoneToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :time_zone, :string
  end
end

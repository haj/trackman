class CreateXmlDestinations < ActiveRecord::Migration
  def change
    create_table :xml_destinations do |t|
      t.references :company, index: true

      t.timestamps
    end
  end
end

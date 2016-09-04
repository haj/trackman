class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.integer :attachable_id, index: true
      t.string :attachable_type
      t.references :tmp_attachment, index: true
      t.string :description

      t.timestamps
    end
  end
end

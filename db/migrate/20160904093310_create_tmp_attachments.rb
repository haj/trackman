class CreateTmpAttachments < ActiveRecord::Migration
  def change
    create_table :tmp_attachments do |t|
      t.string :file

      t.timestamps
    end
  end
end

class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :user, index: true
      t.integer :sender_id, index: true
      t.integer :notificationable_id, index: true
      t.string :notificationable_type
      t.string :action
      t.boolean :is_read, default: false

      t.timestamps
    end
  end
end

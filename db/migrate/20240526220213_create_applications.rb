class CreateApplications < ActiveRecord::Migration[7.1]
  def change
    create_table :applications do |t|
      t.string :name, null: false, index: true
      t.string :token, null: false
      t.integer :chats_count, default: 0

      t.timestamps
    end
  end
end

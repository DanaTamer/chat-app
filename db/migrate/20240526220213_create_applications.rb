class CreateApplications < ActiveRecord::Migration[7.1]
  def change
    create_table :applications do |t|
      t.string :name, null: false, index: true
      t.string :token, null: false

      t.timestamps
    end
  end
end

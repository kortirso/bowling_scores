class CreateThrows < ActiveRecord::Migration
    def change
        create_table :throws do |t|
            t.integer :frame_id
            t.integer :pins, default: 0
            t.timestamps null: false
        end
        add_index :throws, :frame_id
    end
end

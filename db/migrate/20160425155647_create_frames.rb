class CreateFrames < ActiveRecord::Migration
    def change
        create_table :frames do |t|
            t.integer :alley_id
            t.integer :number
            t.integer :pins, default: 10
            t.string :result, default: nil
            t.integer :points, default: 0
            t.timestamps null: false
        end
        add_index :frames, :alley_id
    end
end

class CreateAlleys < ActiveRecord::Migration
    def change
        create_table :alleys do |t|
            t.integer :game_id
            t.string :player, default: ''
            t.integer :points, default: 0
            t.boolean :current_throw, default: false
            t.timestamps null: false
        end
        add_index :alleys, :game_id
    end
end

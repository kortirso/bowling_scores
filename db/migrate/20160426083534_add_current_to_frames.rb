class AddCurrentToFrames < ActiveRecord::Migration
    def change
        add_column :frames, :current, :boolean, default: false
    end
end

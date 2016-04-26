class AddCompletedToFrames < ActiveRecord::Migration
    def change
        add_column :frames, :completed, :boolean, default: false
    end
end

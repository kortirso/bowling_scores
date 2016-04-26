class ChangePinsAtFrames < ActiveRecord::Migration
    def change
        change_table :frames do |t|
            t.change :pins, :integer, default: 0
        end
    end
end

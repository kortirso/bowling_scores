class AddAlleyToThrow < ActiveRecord::Migration
    def change
        add_column :throws, :alley_id, :integer
        add_index :throws, :alley_id
    end
end

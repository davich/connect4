class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.string :data
      t.integer :turns, :default => 0
      t.string :winner
      t.timestamps
    end
  end
end

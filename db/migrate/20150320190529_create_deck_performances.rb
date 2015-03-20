class CreateDeckPerformances < ActiveRecord::Migration
  def change
    create_table :deck_performances do |t|
      t.string :performance_score
      t.string :deck_id

      t.timestamps
    end
  end
end

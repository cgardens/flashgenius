class CreatePerformances < ActiveRecord::Migration
  def change
    create_table :performances do |t|
      t.string :card_id
      t.string :correct
      t.string :previous_card_id
      t.string :certainty

      t.timestamps
    end
  end
end

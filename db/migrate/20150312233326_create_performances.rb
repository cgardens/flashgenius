class CreatePerformances < ActiveRecord::Migration
  def change
    create_table :performances do |t|
      t.string :cards_deck_id
      t.boolean :correct
      t.string :previous_card_id
      t.string :certainty

      t.timestamps
    end
  end
end

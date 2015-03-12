class CreateCardsDecks < ActiveRecord::Migration
  def change
    create_table :cards_decks do |t|
      t.string :deck_id
      t.string :card_id

      t.timestamps
    end
  end
end

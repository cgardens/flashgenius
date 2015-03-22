class CreateDecks < ActiveRecord::Migration
  def change
    create_table :decks do |t|
      t.string :user_id
      t.string :name
      t.float :performance_score
      t.string :hour_mastery_is_attained
      t.string :current_mastery_level
      t.string :hours_until_deck_review

      t.timestamps
    end
  end
end

class CreateDecks < ActiveRecord::Migration
  def change
    create_table :decks do |t|
      t.string :user_id
      t.string :name
      t.float :performance_score
      t.datetime :hour_mastery_is_attained

      t.timestamps
    end
  end
end

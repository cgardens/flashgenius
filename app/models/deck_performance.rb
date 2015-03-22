class DeckPerformance < ActiveRecord::Base
  belongs_to :deck

  after_create :update_deck_record

  def update_deck_record
    new_deck_performance = DeckPerformance.last
    deck = Deck.find(new_deck_performance.deck_id)
    deck.update_attribute(:performance_score, new_deck_performance.performance_score)
  end
end

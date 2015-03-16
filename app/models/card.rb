class Card < ActiveRecord::Base
  has_many :cards_decks
  has_many :performances, through: :cards_decks
end

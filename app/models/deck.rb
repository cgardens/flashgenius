class Deck < ActiveRecord::Base
  belongs_to :user
  has_many :cards_decks
  has_many :cards, through: :cards_decks
end

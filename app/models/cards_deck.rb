class CardsDeck < ActiveRecord::Base
  belongs_to :deck
  belongs_to :card
  has_many :performances
end

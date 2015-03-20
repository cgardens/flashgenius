class Card < ActiveRecord::Base
  belongs_to :deck
  has_many :performances
end

class AlldecksController < ApplicationController

  def index
    @decks = Deck.order('created_at DESC').limit(15)
  end

end

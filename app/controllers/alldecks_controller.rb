class AlldecksController < ApplicationController

  def index
    @decks = Deck.order('created_at DESC').limit(15)
  end

  def live_search_decks
    search_query = params[:search_query].downcase
    if search_query != ''
      deck_matches = Deck.where("name LIKE ?", "%#{search_query}%")
      deck_matches = deck_matches.uniq{|x| x.id}
    end

    render json: {deckMatches: deck_matches}
  end

end

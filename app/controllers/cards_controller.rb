class CardsController < ApplicationController

  def update
    @user = User.find(params[:id])
    @deck = @user.decks.find(params[:deck_id])
    @card = @deck.cards.find(params[:card_id])
    @card.update_attributes(card_info)

    render "/users/#{@user.id}/decks/#{@deck.id}/edit"
  end

  def create
    @user = User.find(params[:id])
    @deck = @user.decks.find(params[:deck_id])
    @card = @deck.cards.create(card_info)

    render "/users/#{@user.id}/decks/#{@deck.id}/edit"
  end

  private
  def card_info
    params.require(:card).permit(:question, :answer_1, :answer_2, :answer_3, :answer_4)
  end

end

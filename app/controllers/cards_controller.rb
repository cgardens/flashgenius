class CardsController < ApplicationController

  def update
    @user = User.find(params[:id])
    @deck = @user.decks.find(params[:deck_id])
    @card = @deck.cards.find(params[:card_id])
    @card.update_attributes(card_info)

    render "/users/#{@user.id}/decks/#{@deck.id}/edit"
  end

  def new
    @user = User.find(params[:user_id])
    @deck = @user.decks.find(params[:deck_id])
    @card = @deck.cards.new()
  end

  def create
    @user = User.find(params[:user_id])
    @deck = @user.decks.find(params[:deck_id])
    @card = @deck.cards.create(card_info)

    redirect_to "/users/#{@user.id}/decks/#{@deck.id}/edit"
  end

  def destroy
    @user = User.find(params[:user_id])
    @deck = @user.decks.find(params[:deck_id])
    @card = @deck.cards.find(params[:id])

    Card.destroy(params[:id])

    render json: {msg: "destroyed: #{params[:id]}"}
  end

  private
  def card_info
    params.require(:card).permit(:question, :answer_1, :answer_2, :answer_3, :answer_4, :answer_number)
  end

end

class CardsController < ApplicationController

  def update
    @user = User.find(params[:user_id])
    @deck = @user.decks.find(params[:deck_id])
    @card = @deck.cards.find(params[:id])
    @card.update_attributes(card_info)

    redirect_to edit_user_deck_path(user_id: @user.id, id: @deck.id)
  end

  def new
    @user = User.find(params[:user_id])
    @deck = @user.decks.find(params[:deck_id])
    @card = @deck.cards.new()
  end


  def edit
    @user = User.find(params[:user_id])
    @deck = @user.decks.find(params[:deck_id])
    @card = @deck.cards.find(params[:id])
  end

  def create
    @user = User.find(params[:user_id])
    @deck = @user.decks.find(params[:deck_id])
    @card = @deck.cards.create(card_info)

    redirect_to edit_user_deck_path(user_id: @user.id, id: @deck.id)
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

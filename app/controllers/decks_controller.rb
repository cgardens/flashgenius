class DecksController < ApplicationController
  def edit
    # /users/1/decks/2/edit
    @user = User.find(params[:user_id])
    @deck = @user.decks.find(params[:id])
    @cards = @deck.cards

    # render json: {user: @user, deck: @deck, cards: @cards}
  end

  def update
    # /users/1/decks/2/edit
    @user = User.find(params[:user_id])
    @deck = @user.decks.find(params[:id])
    @deck.update_attributes(deck_info)

    redirect_to action: :edit, user_id: @user.id, id: @deck.id
  end

  def new
    @user = User.find(params[:user_id])
    end

  def create
    @user = User.find(params[:user_id])
    @deck = @user.decks.new(deck_info)
    if @deck.save
      redirect_to action: :edit, user_id: @user.id, id: @deck.id
    else
      render json: {error_code: '...', msg: 'no good', user: @user, deck: @deck}
    end
  end

  private
  def deck_info
    params.require(:deck).permit(:name)
  end

end

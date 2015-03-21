class DecksController < ApplicationController

  def edit
    # /users/1/decks/2/edit
    @user = User.find(params[:user_id])
    @deck = @user.decks.find(params[:id])
    @cards = @deck.cards

    # render json: {user: @user, deck: @deck, cards: @cards}
  end

  def show
    # /users/1/decks/2/edit
    @user = User.find(params[:user_id])
    @deck = @user.decks.find(params[:id])
    @cards = @deck.cards

    # render json: {user: @user, deck: @deck, cards: @cards}
  end

  def take_quiz
    # p params
    @user = User.find(params[:user_id])
    @deck = @user.decks.find(params[:id])
    @cards = @deck.cards
  end

  def start_quiz
    @user = User.find(params[:user_id])
    @deck = @user.decks.find(params[:id])
    @cards = @deck.cards
    @cards = @cards.shuffle

    render json: {user: @user, deck: @deck, cards: @cards}
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

  def validate
    p "="*50 + "params in validate is: "
    p params
    @user = User.find(params[:user_id])
    @deck = @user.decks.find(params[:deck_id])
    @card = @deck.cards.where(id: params[:card_id])[0]
    performance = @card.performances.create(certainty: params[:certainty], correct: params[:correct], previous_card_id: params[:previous_card_id])
    p Performance.last
    p performance

    render json: {msg: 'success'}
  end

  def next_card
    #happens client side, consider removing
  end

  def copy_deck
    old_deck = Deck.find(params[:id])
    new_deck = User.find(current_user).decks.create(name: old_deck.name)
    new_deck.save

    old_deck.cards.each do |card|
      new_deck.cards.create(question: card.question, answer_1: card.answer_1, answer_2: card.answer_2, answer_3: card.answer_3, answer_4: card.answer_4, answer_number: card.answer_number)
    end

    redirect_to user_deck_path(user_id: new_deck.user_id, id: new_deck.id)
  end

  def end_quiz
    deck = Deck.find(params[:id])
    calculate_deck_performance_score(deck)

    redirect_to user_path(params[:user_id])
  end

  private

  def calculate_deck_performance_score(deck)
    performance_score = calculate_single_deck_ps(deck)
    p '*'*50 + ' performance_score'
    p performance_score

    deck.deck_performances.create!(performance_score: performance_score)
  end

  def calculate_single_card_ps(card) #Returns properly weighted performance score for each card
    # p "Card is: "
    # p card #Shit, this is actually a deck
    card_performances = card.performances
    individual_card_performance_score = 0
    card_performances.each do |performance|
      individual_card_performance_score += performance.correct.to_i * performance.certainty.to_f / card_performances.length
    end
    return individual_card_performance_score
  end

  def calculate_single_deck_ps(deck)
    p "Deck is: "
    p deck
    cards = deck.cards
    p "Cards is: "
    p cards
    deck_performance_score = 0
    cards.each do |card|
      deck_performance_score += (calculate_single_card_ps(card) / cards.length)
    end
    return deck_performance_score
  end

  def deck_info
    params.require(:deck).permit(:name)
  end

  #this was copied from the decks controller. DRY THIS OUT
  def current_user
    if session[:id]
      session[:id]
    else
      p 'no user logged in'
    end
  end

end

class UsersController < ApplicationController

  def index
    @users = User.all
  end

  #------- methods to order decks ----------------------------------------------

  # def calculate_single_card_ps(card) #Returns properly weighted performance score for each card
  #   # p "Card is: "
  #   # p card #Shit, this is actually a deck
  #   card_performances = card.performances
  #   individual_card_performance_score = 0
  #   card_performances.each do |performance|
  #     individual_card_performance_score += performance.correct.to_i * performance.certainty.to_f / card_performances.length
  #   end
  #   return individual_card_performance_score
  # end

  # def calculate_single_deck_ps(deck)
  #   # p "Deck is: "
  #   # p deck
  #   cards = deck.cards
  #   # p "Cards is: "
  #   # p cards
  #   deck_performance_score = 0
  #   cards.each do |card|
  #     deck_performance_score += (calculate_single_card_ps(card) / cards.length)
  #   end
  #   return deck_performance_score
  # end

  def ordered_decks(user)
    all_decks = user.decks
    p "*"*100
    p "All_Decks: "
    p all_decks
    #Need to update the performance score for each deck.  Performance score is between -1 and 1
    # all_decks.each do |deck|
    #   deck.deck_performances.create!(performance_score: calculate_single_deck_ps(deck))
    # end
    #order decks by performance scores
    # p all_decks
    ordered_decks = all_decks.order('performance_score DESC')
    # ordered_decks = all_decks.includes(:deck_performances).order('deck_performances.performance_score DESC')
    # p all_decks
    # all_decks.sort_by! {|a,b| a.performance_score <=> b.performance_score }
    return ordered_decks
  end










  #------------------------------------------------------------------------------

  def show
    @user = User.find(params[:id])
    #Order the decks based upon most recent performance score
    @decks = ordered_decks(@user)


    # render json: {user: @user, decks: @decks}
  end

  def create
    user_info = downcase_user_info(user_info)
    @user = User.new(user_info)
    if @user.save
      redirect_to action: :show, id: @user.id
    else
      render json: {error_code: '...', msg: 'no good', user: @user}
    end
  end

  def live_search_users
    search_query = params[:search_query].downcase
    user_matches = User.where("email LIKE ?", "%#{search_query}%")
    user_matches += User.where("first_name LIKE ?", "%#{search_query}%")
    user_matches = user_matches.uniq{|x| x.id}

    render json: {userMatches: user_matches}
  end

  private

  def user_info
    params.require(:user).permit(:email, :first_name, :google_id)
  end

  def downcase_user_info(user_info)
    user_info.each do |info|
      info.downcase!
    end

    user_info
  end

end

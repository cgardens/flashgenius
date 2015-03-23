class DecksController < ApplicationController

  before_action :require_login

  def edit
    @user = User.find(params[:user_id])
    @deck = @user.decks.find(params[:id])
    @cards = @deck.cards
  end

  def destroy
    @deck = Deck.find(params[:id])
    @deck.destroy

    redirect_to user_path(params[:user_id])
  end

  def show
    @user = User.find(params[:user_id])
    @deck = @user.decks.find(params[:id])
    @cards = @deck.cards
  end

  def take_quiz
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
    #When deck is first created the corresponding performance scores need to be set to indeterminate
    @deck = @user.decks.new(name: deck_info[:name], hour_mastery_is_attained: "indeterminate, need more data", current_mastery_level: "indeterminate, need more data", hours_until_deck_review: "indeterminate, need more data" )
    if @deck.save
      redirect_to action: :edit, user_id: @user.id, id: @deck.id
    else
      render json: {error_code: '...', msg: 'no good', user: @user, deck: @deck}
    end
  end

  def validate
    @user = User.find(params[:user_id])
    @deck = @user.decks.find(params[:deck_id])
    @card = @deck.cards.where(id: params[:card_id])[0]
    performance = @card.performances.create(certainty: params[:certainty], correct: params[:correct], previous_card_id: params[:previous_card_id])

    render json: {msg: 'success'}
  end

  def copy_deck
    old_deck = Deck.find(params[:id])
    new_deck = User.find(current_user).decks.create(name: old_deck.name, hour_mastery_is_attained: "indeterminate, need more data", current_mastery_level: "indeterminate, need more data", hours_until_deck_review: "indeterminate, need more data")
    new_deck.save

    old_deck.cards.each do |card|
      new_deck.cards.create(question: card.question, answer_1: card.answer_1, answer_2: card.answer_2, answer_3: card.answer_3, answer_4: card.answer_4, answer_number: card.answer_number)
    end

    redirect_to user_path(id: new_deck.user_id)
  end

  def end_quiz
    @user = User.find(params[:user_id])
    deck = Deck.find(params[:id])
    calculate_deck_performance_score(deck)  #Works
    calculate_and_save_hour_mastery_is_attained(deck)  #Works
    deck.reload
    # #CURRENT MASTERY LEVEL
    current_mastery_level = current_mastery_level(deck)  #Works
    # #WHEN TO REVIEW THE DECK (OPTIMAL TIME)
    hours_until_deck_review = calculate_hours_until_deck_review((deck.performance_score + 1) * 50)  #Works, could be updated for better fit
    deck.update_attributes(current_mastery_level: current_mastery_level, hours_until_deck_review: hours_until_deck_review)

    total = 0
    correct = 0
    deck.cards.each do |card|
      total += 1
      if card.performances.last.correct == "1"
        correct += 1
      end
    end

    @score = (correct.to_f / total) * 100
    # redirect_to user_path(params[:user_id])
  end

  private

   def calculate_hours_until_deck_review(current_master_level_percent)
    # x = current proficiency as integer percent
    # y = hours until deck should be reviewed
    # y =(0.93908028) * (1.06487168^x)
    p "HOURS UNTIL DECK REVIEW " + "=+"*50
    p hours_until_deck_review = ((0.93908028) * (1.06487168 ** current_master_level_percent )).round(2)
  end

  def current_mastery_level(deck)
    # # !!!! Need performance scores to be in integer percents, this should be refactored to a case statement with breaks.
    # p "CURRENT PROFICIENCY SCORE " + "+"*50
    # p deck.performance_score
    current_proficiency_score = (deck.performance_score + 1) * 50 #!!!! Something from database
    current_master_level = ''
    if current_proficiency_score > 95
      current_master_level = "master"
    elsif current_proficiency_score <= 95 && current_proficiency_score > 70
      current_master_level = "adept"
    elsif current_proficiency_score > 45 && current_proficiency_score <= 70
      current_master_level = "intermediate"
    else current_proficiency_score <= 45
      current_master_level = "beginner"
    end
    p "CURRENT MASTER LEVEL" + "*"*100
    p current_master_level
  end

  def calculate_and_save_hour_mastery_is_attained(deck)
    #Now need to calculate HOW LONG UNTIL MASTERY using the best fit linear equation for the deck.

    #Need the deck scores in one array --- y values.
    deck_scores = []  #These are integer percents.
    #Need the timestamps corresponding to each  --- x values
    deck_scores_times = []
    deck.deck_performances.each do |deck_performance|
      deck_scores.push( (deck_performance.performance_score.to_f + 1) * 50)
      deck_scores_times.push(deck_performance.created_at.to_i)
    end

    #If there are less than 3 data points, no point in calculating or changing 'hour mastery is attained' so just return
    if deck_scores.length < 4
      return   #hour_mastery_is_attained = "Indeterminate, need more data points"
    end

    #Sufficient Data Points so Initialize SimpleLinearRegression object
    linear_regression_object = SimpleLinearRegression.new(deck_scores_times,deck_scores)
    #Calculate what hour in the future mastery will be attained
    #x = (95 - b) / m
    slope = linear_regression_object.slope
    yintercept = linear_regression_object.y_intercept
    hour_mastery_is_attained = (95 - yintercept) / slope

    if hour_mastery_is_attained == 'NaN'
      #The linear regression has failed because there is only 1 data point or, they are all equal
      hour_mastery_is_attained = "Indeterminate, need more data"
      Deck.find(deck.id).update_attribute(:hour_mastery_is_attained, hour_mastery_is_attained)
    elsif slope < 0
      #if slopes are negative, hour mastery is attained is infinite, but more encouraging to say "greater than 1 month"
      hour_mastery_is_attained = "Greater than 1 month"
      Deck.find(deck.id).update_attribute(:hour_mastery_is_attained, hour_mastery_is_attained)
    else
      #everything has worked correctly, convert to UNIX time, and save in database
      hour_mastery_is_attained.to_i
      Deck.find(deck.id).update_attribute(:hour_mastery_is_attained, hour_mastery_is_attained)
    end


    #Test Fit:
    #  {{0.0,1427073195},{0.0,1427073245},{3.333333333333349,1427073280},{7.500000000000001,1427073345}}
    # 1.42707×10^9+16.7397 x
    # "**************************************************"
    # "**************************************************"
    # "deck_scores: "
    # [0.0, 0.0, 3.333333333333349, 7.500000000000001]
    # "deck_scores_times: "
    # [1427073195, 1427073245, 1427073280, 1427073345]
    # "slope: "
    # 0.05339975528753717
    # "yintercept: "
    # -76205360.69513637
    # "hour_mastery_is_attained"
    # 1427074998.467676
    # (95 - yintercept) / slope
    # (95 - -76205360.69513637) / 0.05339975528753717
    # "**************************************************"
    # "**************************************************"

  end

  def calculate_deck_performance_score(deck)
    performance_score = calculate_single_deck_ps(deck)
    # p '*'*50 + ' performance_score'
    #Rounding to get rid of insanely long floats
    performance_score.round(5)
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

  #simple linear regression
  class SimpleLinearRegression
    def initialize(xs, ys)
      @xs, @ys = xs, ys
      if @xs.length != @ys.length
        raise "Unbalanced data. xs need to be same length as ys"
      end
    end

    def y_intercept
      mean(@ys) - (slope * mean(@xs))
    end

    def slope
      x_mean = mean(@xs)
      y_mean = mean(@ys)

      numerator = (0...@xs.length).reduce(0) do |sum, i|
        sum + ((@xs[i] - x_mean) * (@ys[i] - y_mean))
      end

      denominator = @xs.reduce(0) do |sum, x|
        sum + ((x - x_mean) ** 2)
      end

      (numerator / denominator)
    end

    def mean(values)
      total = values.reduce(0) { |sum, x| x.to_i + sum }
      Float(total) / Float(values.length)
    end
  end

  #this was copied from the decks controller. DRY THIS OUT
  def current_user
    if session[:id]
      session[:id]
    else
      p 'no user logged in'
    end
  end

  def require_login
    redirect_to root_path if !session[:id]
  end


end

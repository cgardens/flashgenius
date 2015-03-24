class UsersController < ApplicationController

  before_action :require_login

  def index
    @user = User.find(session[:id]) if session[:id]
    @users = User.all
  end

  def ordered_decks(user)
    all_decks = user.decks

    ordered_decks = all_decks.order('performance_score DESC').reverse

    return ordered_decks
  end

  def show
    @user = User.find(params[:id])
    #Order the decks based upon most recent performance score
    @decks = ordered_decks(@user)
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

  def update
    @user = User.find(params[:id])
    @user.update_attributes(user_info)

    redirect_to user_path(@user)
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
    params.require(:user).permit(:email, :first_name, :google_id, :username)
  end

  def downcase_user_info(user_info)
    user_info.each do |info|
      info.downcase!
    end

    user_info
  end

  def require_login
    redirect_to root_path if !session[:id]
  end

end

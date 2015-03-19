class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @decks = @user.decks

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

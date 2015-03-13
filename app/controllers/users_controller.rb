class UsersController < ApplicationController

  def index
    @users = User.all

    render json: @users
  end

  def show
    @user = User.find(params[:id])
    @decks = @user.decks

    # render json: {user: @user, decks: @decks}
  end

  def create
    @user = User.new(user_info)
    if @user.save
      redirect_to action: :show, id: @user.id
    else
      render json: {error_code: '...', msg: 'no good', user: @user}
    end
  end

  private
  def user_info
    params.require(:user).permit(:email, :first_name, :google_id)
  end


end

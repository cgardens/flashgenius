require 'rails_helper'

RSpec.describe DecksController, type: :controller do
  # let(:user){User.create(email: 'prettyprincess@dev.com', first_name: 'pretty')}
  # let(:deck){user.decks.create(name: 'maths')}

  describe 'GET edit' do
    it 'responds with a 200 status' do
      # ??? Why does this not work in the let block?
      user = User.create(email: 'prettyprincess@dev.com', first_name: 'pretty')
      user.decks.create(name: 'maths')

      get :edit, {user_id: 1, id: 1}

      expect(response.status).to eq(200)
    end
  end

  describe 'PUT update' do
    it 'responds with a 302 status' do
      user = User.create(email: 'prettyprincess@dev.com', first_name: 'pretty')
      user.decks.create(name: 'maths')

      put :update, {user_id: 1, id: 1, deck: {name: 'abaci'}}

      expect(response.status).to eq(302)
    end
  end

  describe 'POST create' do
    it 'responds with a 302 status' do
      User.create(email: 'prettyprincess@dev.com', first_name: 'pretty')
      expect{
        post :create, {user_id: 1, id: 1, deck: {name: 'bus routes'}}
      }.to change{Deck.count}.by(1)
    end
  end
end

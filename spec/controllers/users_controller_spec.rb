require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe 'GET index' do
    it 'responds with 200 status' do
      get :index
      expect(response.status).to eq(200)
    end
  end

  describe 'POST create' do
    it 'responds with 302 status' do
      post :create,user: {email: 'sherif@dev.com', first_name: 'sherif'}
      expect(response.status).to eq(302)
    end

    it 'saves create user to database' do
      expect{
        post :create, user: {email: 'sherif@dev.com', first_name: 'sherif'}
      }.to change{User.count}.by(1)
    end
  end


end

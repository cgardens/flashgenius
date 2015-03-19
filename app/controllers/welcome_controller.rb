class WelcomeController < ApplicationController
  Dotenv.load

  def index
  end

  def auth
    redirect_to "https://accounts.google.com/o/oauth2/auth?scope=email%20profile&state=security_token%3D138r5719ru3e1%26url%3Dhttps://oa2cb.example.com/myHome&redirect_uri=http://localhost:3000/welcome/oauth2callback&response_type=code&client_id=#{ENV['GOOGLE_CLIENT_ID']}&approval_prompt=force"
  end

  def oauth2callback
    #code coming back from google
    code = params[:code]
    options = {
      body: {
        code: code,
              client_id: ENV['GOOGLE_CLIENT_ID'],
              client_secret: ENV['GOOGLE_CLIENT_SECRET'],
              redirect_uri: 'http://localhost:3000/welcome/oauth2callback',
              grant_type: 'authorization_code'
      }
    }
    p 'post request'
    res1 = HTTParty.post('https://www.googleapis.com/oauth2/v3/token', options)
    p access_token = res1['access_token']
    res2 = HTTParty.get("https://www.googleapis.com/plus/v1/people/me?scope=openid%20email%20profile&access_token=#{access_token}")
    p 'res2'
    p res2

    p 'res2.body'
    p res2_body = JSON.parse(res2.body)

    p "res2_body['id']"
    p res2_body['id']

    p "res2_body['name']['givenName']"
    p res2_body['name']['givenName']

    p "res2_body['emails'][0]['value']"
    p res2_body['emails'][0]['value']

    User.create(first_name: res2_body['name']['givenName'], email: res2_body['emails'][0]['value'], google_id: res2_body['id'])
    render :index
  end

  def oauth_login
    p params
    render :index
  end

end

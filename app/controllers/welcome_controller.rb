class WelcomeController < ApplicationController
  Dotenv.load

  def index
    # p "#{host}#{port_string}"
    # p Request.host
    p 'root url'
    p {root_url}
    p 'request'
    p request.host
    p 'request.original_fullpath'
    p request.original_fullpath
    p 'request.original_url'
    p request.original_url
  end

  def splash
  end

  def auth
    p 'get_base_url'
    p get_base_url
    p "request.original_url1"
    p "#{request.original_url}"
    redirect_to "https://accounts.google.com/o/oauth2/auth?scope=email%20profile&state=security_token%3D138r5719ru3e1%26url%3Dhttps://oa2cb.example.com/myHome&redirect_uri=#{get_base_url}welcome/oauth2callback&response_type=code&client_id=#{ENV['GOOGLE_CLIENT_ID']}"
  end

  def oauth2callback
    #code coming back from google

    login_with_google(params[:code])

    redirect_to user_path(session[:id])
  end

  def logout
    logout_user
  end

  private

  def login_with_google(code)
    access_token_and_expiration = get_google_user_access_token(code)

    user_info = get_google_user_info(access_token_and_expiration[:access_token])

    user_info[:access_token] = access_token_and_expiration[:access_token]
    user_info[:expiration_time] = access_token_and_expiration[:expiration_time]
    user = User.where(google_id: user_info[:google_id])[0]

    if !user
      user = User.new(user_info)
      user.save
    end

    create_user_session(user)
  end

  def get_google_user_access_token(code)
    options = {
      body: {
        code: code,
              client_id: ENV['GOOGLE_CLIENT_ID'],
              client_secret: ENV['GOOGLE_CLIENT_SECRET'],
              redirect_uri: "#{get_base_url}welcome/oauth2callback",
              grant_type: 'authorization_code'
      }
    }

    res = HTTParty.post('https://www.googleapis.com/oauth2/v3/token', options)
    access_token_and_expiration = {access_token: res['access_token'], expiration_time: Time.now + 60 * 60 }
  end

  def get_google_user_info(access_token)
    res = HTTParty.get("https://www.googleapis.com/plus/v1/people/me?scope=openid%20email%20profile&access_token=#{access_token}")

    res_body = JSON.parse(res.body)

    user_info = {}
    user_info[:google_id] = res_body['id']
    user_info[:first_name] = res_body['name']['givenName']
    user_info[:email] = res_body['emails'][0]['value']
    user_info[:image_url] = res_body['image']['url']

    user_info
  end

  def create_user_session(user)
    if user
      session[:id] = user.id
      session[:email] = user.email
      session[:first_name] = user.first_name
      session[:google_id] = user.google_id
    else
      p 'invalid user'
    end
  end

  def logout_user
    session.clear

    redirect_to root_path
  end

  def get_base_url
    match_local_host = request.original_url.match(/(localhost:\d*\/)/)
    match_url= request.original_url.match(/^.*.com\/|^.*.net\/|^.*.gov\/|^.*.org\//)
    if match_local_host
      "http://#{match_local_host[0]}"
    elsif match_url
      p 'match url url'
      p match_url[0]
      p "https://regression-fit-knowledge-cards.herokuapp.com/"
    else
      p 'could not scrape url'
    end
  end


end

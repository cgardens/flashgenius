module ApplicationHelper

  def current_user
    if session[:id]
      session[:id]
    else
      p 'no user logged in'
    end
  end

  def logged_in?
    if session[:id]
      return true
    else
      return false
    end
  end


end

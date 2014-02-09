class DropboxController < ApplicationController
  require 'dropbox_sdk'

  APP_KEY = '4m5uk5t7t6xv14t'
  APP_SECRET = 'yki13jvirz43qnf'
  REDIRECT_URI = "http://localhost:3000/dbconnected"

  def connect
    flow = DropboxOAuth2Flow.new(APP_KEY, 
                                 APP_SECRET, 
                                 REDIRECT_URI,
                                 session,
                                 :dropbox_auth_csrf_token)
    redirect_to "#{flow.start()}&redirect_uri=#{REDIRECT_URI}"
  end

  def connected
    flow = DropboxOAuth2Flow.new(APP_KEY, 
                                 APP_SECRET, 
                                 REDIRECT_URI,
                                 session,
                                 :dropbox_auth_csrf_token)
    access_token, user_id = flow.finish(params)

    if session[:user_id]
      user = User.find(session[:user_id])
      user.update_attribute(:dropbox_access_token, access_token)
      user.update_attribute(:dropbox_id, user_id)
    else
      puts "Error -> Need to link soundcloud first"
    end

    redirect_to connect_url
  end

end

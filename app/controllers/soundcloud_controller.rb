class SoundcloudController < ApplicationController

  CLIENT_ID = "8c32c9d9ea5b39e4fc3dc6669488c817"
  CLIENT_SECRET = "18951d18fd3bf864e96fdbd2bf1b16fc"
  REDIRECT_URI = "http://localhost:3000/scconnected"

  def connect
    client = Soundcloud.new(:client_id => CLIENT_ID,
                            :client_secret => CLIENT_SECRET,
                            :redirect_uri => REDIRECT_URI)
    redirect_to client.authorize_url()
  end


  def connected
    my_client = Soundcloud.new(:client_id => CLIENT_ID,
                               :client_secret => CLIENT_SECRET,
                               :redirect_uri => REDIRECT_URI)
    code = params[:code]
    tokens = my_client.exchange_token(:code => code)

    access_token = tokens.access_token
    refresh_token = tokens.refresh_token
    expires_at = tokens.expires_at

    client = Soundcloud.new(:access_token => access_token)
    me = client.get('/me')

    new_user = User.find_or_create_by_soundcloud_id(me.id)
    new_user.update_attributes(soundcloud_username: me.username,
                               soundcloud_access_token: access_token,
                               soundcloud_refresh_token: refresh_token,
                               soundcloud_expires_at: expires_at)
    new_user.save
    session[:user_id] = new_user.id

    redirect_to connect_url
  end

end

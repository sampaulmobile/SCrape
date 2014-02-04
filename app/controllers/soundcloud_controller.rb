class SoundcloudController < ApplicationController

  def connect
    client = Soundcloud.new(:client_id => '8c32c9d9ea5b39e4fc3dc6669488c817',
                            :client_secret => '18951d18fd3bf864e96fdbd2bf1b16fc',
                            :redirect_uri => 'http://localhost:3000/connected')
    redirect_to client.authorize_url()
  end


  def connected
    my_client = Soundcloud.new(:client_id => '8c32c9d9ea5b39e4fc3dc6669488c817',
                            :client_secret => '18951d18fd3bf864e96fdbd2bf1b16fc',
                            :redirect_uri => 'http://localhost:3000/connected')
    code = params[:code]
    tokens = my_client.exchange_token(:code => code)

    access_token = tokens.access_token
    refresh_token = tokens.refresh_token
    expires_at = tokens.expires_at

    client = Soundcloud.new(:access_token => access_token)
    me = client.get('/me')

    new_user = User.create(soundcloud_id: me.id,
                           soundcloud_username: me.username,
                           soundcloud_access_token: access_token,
                           soundcloud_refresh_token: refresh_token,
                           soundcloud_expires_at: expires_at)
    new_user.save

    redirect_to finished_url
  end

end

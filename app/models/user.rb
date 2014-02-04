class User < ActiveRecord::Base

  has_many :likes
  has_many :tracks, through: :likes, foreign_key: "soundcloud_id"


  def self.update_likes(count = 10)
    users = User.order("likes_last_updated DESC").limit(count)
    users.each { |u| UserUpdater.perform_async(u.id) }
  end

  def soundcloud_client(options={})
    options= {
      :expires_at    => expires_at,
      :access_token  => access_token,
      :refresh_token => refresh_token
    }.merge(options)

    client = self.class.soundcloud_client(options)

    client.on_exchange_token do
      self.update_attributes!({
        :soundcloud_access_token  => client.access_token,
        :soundcloud_refresh_token => client.refresh_token,
        :soundcloud_expires_at    => client.expires_at,
      })
    end

    client
  end

end

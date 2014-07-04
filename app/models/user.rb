class User < ActiveRecord::Base

  has_many :likes
  has_many :tracks, through: :likes, foreign_key: "soundcloud_id"


  def update_likes(num_pages = 10)
    page_size = 50
    finished = false

    client = Soundcloud.new(:access_token => self.soundcloud_access_token)

    Rails.logger.info "#{self.soundcloud_username} - Starting update of likes"

    (0..num_pages).each do |i|

      tracks = client.get('/me/favorites', offset: page_size * i)
      tracks.each do |track|
        if !Like.where(track_id: track.id, user_id: self.id).blank?
          finished = true
          break 
        end

        if Track.where(soundcloud_id: track.id).blank?
          download_url = track.downloadable ? track.download_url : ""

          t = Track.create(soundcloud_id: track.id, title: track.title, 
                           download_count: 0, download_url: download_url,
                           duration: track.duration/1000)
          t.save
        else
          t = Track.find_by_soundcloud_id(track.id)
        end

        l = Like.create(track_id: track.id, user_id: self.id)
        l.save

        Resque.enqueue(TrackDownloader, t.id, self.id)

        # TrackDownloader.perform_async(download_url, 
        #                               title, 
        #                               self.soundcloud_username, 
        #                               self.dropbox_access_token)
      end 

      break if finished
    end

    self.update_attribute(:likes_last_updated, Time.now)
    Rails.logger.info "#{self.soundcloud_username} - Finished update of likes"
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

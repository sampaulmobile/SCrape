class UserUpdater
  include Sidekiq::Worker

  def perform(user_id, num_pages = 10)
    page_size = 50
    finished = false

    user = User.find(user_id)
    client = Soundcloud.new(:access_token => user.soundcloud_access_token)

    (0..num_pages).each do |i|

      tracks = client.get('/me/favorites', offset: page_size * i)
      tracks.each do |track|
        if !Like.where(track_id: track.id, user_id: user.id).blank?
          finished = true
          break 
        end

        download_url = ""
        title = ""
        if Track.where(soundcloud_id: track.id).blank?
          download_url = track.downloadable ? track.download_url : ""

          t = Track.create(soundcloud_id: track.id, title: title, 
                           download_count: 0, download_url: download_url)
          t.save
        else
          t = Track.find_by_soundcloud_id(track.id)
          title = t.title
          download_url = t.download_url
        end

        l = Like.create(track_id: track.id, user_id: user.id)
        l.save

        TrackDownloader.perform_async(download_url, 
                                      title, 
                                      user.soundcloud_username, 
                                      user.dropbox_access_token)
      end 

      break if finished
    end
  end

end

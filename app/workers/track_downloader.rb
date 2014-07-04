class TrackDownloader
    @queue = :downloader 
  # include Sidekiq::Worker
  require 'dropbox_sdk'
  require 'open-uri'
  require 'open_uri_redirections'

  CLIENT_ID = "8c32c9d9ea5b39e4fc3dc6669488c817"

  def self.perform(track_id, user_id)
    u = User.find(user_id)
    if !u
        puts "No user found for u_id: #{user_id}"
        Rails.logger.error "No user found for u_id: #{user_id}"
        return
    end

    username = u.soundcloud_username
    db_token = u.dropbox_access_token

    t = Track.find(track_id)
    if !t
        puts "No track found for t_id: #{track_id}"
        Rails.logger.error "No track found for t_id: #{track_id}"
        return
    end

    url = t.download_url
    title = t.title
    if url == "" || !title.is_a?(String) || !username.is_a?(String)
        puts "No valid download url/title"
        Rails.logger.info "No valid download url/title"
        return
    end

    filename = title.gsub(/[\x00\/\\:\*\?\"<>\|]/, '_')
    uname = username.gsub(/[\x00\/\\:\*\?\"<>\|]/, '_')

    Rails.logger.info "#{username} - Starting download of #{title}"

    client = DropboxClient.new(db_token)
    dl_url = "#{url}?client_id=#{CLIENT_ID}"
    client.put_file("/#{uname}/#{filename}.mp3", open(dl_url, :allow_redirections => :all))

    Rails.logger.info "#{username} - Finished download of #{filename}"

    # `mkdir -p songs/#{uname}`
    # cmd = "curl #{url}?client_id=#{CLIENT_ID} -L > songs/'#{uname}'/'#{filename}.mp3'"
    # `#{cmd}`
  end

end

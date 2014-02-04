class TrackDownloader
  include Sidekiq::Worker

  CLIENT_ID = "8c32c9d9ea5b39e4fc3dc6669488c817"

  def perform(url, username, title)
    return if url == ""

    filename = title.gsub(/[\x00\/\\:\*\?\"<>\|]/, '_')
    uname = username.gsub(/[\x00\/\\:\*\?\"<>\|]/, '_')

    Rails.logger.info "Downloading #{title}"
    `mkdir -p songs/#{uname}`
    cmd = "curl #{url}?client_id=#{CLIENT_ID} -L > songs/'#{uname}'/'#{filename}.mp3'"
    `#{cmd}`
  end

end

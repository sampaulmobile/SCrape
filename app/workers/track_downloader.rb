class TrackDownloader
  include Sidekiq::Worker
  require 'dropbox_sdk'
  require 'open-uri'
  require 'open_uri_redirections'

  CLIENT_ID = "8c32c9d9ea5b39e4fc3dc6669488c817"

  def perform(url, title, username, db_token)
    return if url == "" || !title.is_a?(String) || !username.is_a?(String)

    filename = title.gsub(/[\x00\/\\:\*\?\"<>\|]/, '_')
    uname = username.gsub(/[\x00\/\\:\*\?\"<>\|]/, '_')

    Rails.logger.info "Downloading #{title}"

    client = DropboxClient.new(db_token)
    dl_url = "#{url}?client_id=#{CLIENT_ID}"
    client.put_file("/#{uname}/#{filename}.mp3", open(dl_url, :allow_redirections => :all))
    # `mkdir -p songs/#{uname}`
    # cmd = "curl #{url}?client_id=#{CLIENT_ID} -L > songs/'#{uname}'/'#{filename}.mp3'"
    # `#{cmd}`
  end

end

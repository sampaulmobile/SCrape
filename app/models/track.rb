class Track < ActiveRecord::Base

  has_many :likes
  has_many :users, through: :likes, foreign_key: "soundcloud_id"


  def download(like_id, user_id)

    user = User.find(user_id)
    like = Like.find(like_id)
    Rails.logger.info "Downloading #{self.inspect}"

    return if self.download_url == ""

    like.update_attribute(:downloading, true)
    like.increment!(:try_count)
    `mkdir -p songs/#{user.soundcloud_username}`
    cmd = "curl #{self.download_url}?client_id=8c32c9d9ea5b39e4fc3dc6669488c817 -L > songs/'#{user.soundcloud_username}'/'#{self.title}.mp3'"
    `#{cmd}`

    # when download successful
    like.update_attribute(:downloading, false)
    like.update_attribute(:downloaded, true)
    self.increment!(:download_count)

    # possibly split into download/upload?
    # TrackUploader.perform_async(DATA)
  end



end

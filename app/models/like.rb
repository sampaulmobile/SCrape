class Like < ActiveRecord::Base

  belongs_to :user, foreign_key: "user_id", class_name: "User"
  belongs_to :track, primary_key: "soundcloud_id", foreign_key: "track_id", class_name: "Track"

  def self.process_likes(count = 10)
    likes = where("NOT downloading AND NOT downloaded AND try_count < 5").order("created_at DESC").limit(count)
    likes.each { |l| l.download }
  end

  def download
    TrackDownloader.perform_async(self.id, 
                                  self.track.title,
                                  self.user.soundcloud_username, 
                                  self.user.dropbox_access_token)
  end

end

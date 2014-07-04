class UserUpdater
    @queue = :updator
  # include Sidekiq::Worker


  def self.perform
      count = 10
      users = User.order("likes_last_updated DESC").limit(count)
      users.each { |u| u.update_likes }
  end

end

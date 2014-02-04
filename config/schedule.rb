# Use this file to easily define all of your cron jobs.
#

set :output, "/Users/sampaul/Development/SBP/SCrape/cron_log.log"

every 10.minutes do
  command 'rvm use 2.0.0@SCrape'
  runner "User.update_likes", environment: "development"
end

every 10.minutes do
  command 'rvm use 2.0.0@SCrape'
  runner "Like.process_likes", environment: "development"
end


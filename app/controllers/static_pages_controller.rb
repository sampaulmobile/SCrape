class StaticPagesController < ApplicationController

  def welcome
  end

  def connect
    @sc_connected = current_user && current_user.soundcloud_username
    @db_connected = current_user && current_user.dropbox_id
  end

  def finished
  end

end

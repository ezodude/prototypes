require "rubygems"
require 'rbosa'

class QuicktimePodcastRadio
  PLAYLIST = [
    "http://files.libertyfund.org/econtalk/y2009/Grahaminnovation.mp3",
    "http://itc.conversationsnetwork.org/audio/download/ITC.TM-DanBricklin-2009.05.04.mp3",
    "http://www.gillespetersonworldwide.com/podcasts/gilles_peterson-vol01-no12.mp3",
    "http://video.ted.com/talks/podcast/audio/ted_gilbert_d_2004.mp3",
    "http://itc.conversationsnetwork.org/audio/download/ITC.oscon-Conway-2008.07.22.mp3"
  ]
  
  MAX_SOUND_VOLUME = 250
  SOUND_VOLUME_INCREMENT = MAX_SOUND_VOLUME / 10
  
  def initialize
    @quick_time_app = OSA.app('QuickTime Player')
    OSA.wait_reply = true
  end
  
  def play
    PLAYLIST.each do |podcast_location|
      @quick_time_app.geturl(podcast_location)
      sleep(1)
      
      @current_podcast = @quick_time_app.documents[0]
      @current_podcast.play
      sleep(1) while @current_podcast.playing?
      @quick_time_app.close(@current_podcast)
    end
  end
  
  def playing?
    @current_podcast && @current_podcast.playing?
  end
  
  def stop
    return unless playing?
    @quick_time_app.close(@current_podcast)
    @current_podcast = nil
  end
  
  def change_volume_to(ten_based_value)
    return unless playing?
    @current_podcast.sound_volume = ten_based_value * SOUND_VOLUME_INCREMENT
  end
end
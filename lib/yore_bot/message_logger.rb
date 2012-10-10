require 'fileutils'

module YoreBot
end

class YoreBot::MessageLogger
  include FileUtils

  attr_accessor :last_frame

  def initialize
    @last_frame = frame
  end

  def frame
    Time.now.to_i / 900
  end

  def store message
    now = Time.now.to_i
    current_frame = frame
    if current_frame > last_frame
      mv 'history.log', "#{last_frame}.log"
      last_frame = current_frame
    end
    File.open('history.log', 'a') {|f| f.puts "#{now} #{message.raw}" }
  end
end
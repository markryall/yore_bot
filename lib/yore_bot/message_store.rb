require 'action_view'

module YoreBot
  Message = Struct.new :time, :nick, :content
end

class YoreBot::MessageStore
  include ActionView::Helpers::DateHelper

  def initialize
    @messages = []
  end

  def store message
    @messages.push Message.new Time.now, message.user.nick, message.message
  end

  def messages_since start
    @messages.select {|m| m.time > start }
  end

  def retrieve user, seconds
    now = Time.now
    start = now - seconds
    messages = messages_since start
    if messages.empty?
      user.reply "no recent messages since then"
    else
      messages.each do |m|
        description = distance_of_time_in_words now, m.time
        user.reply "#{m.nick}: #{m.content} (#{description} ago)"
      end
    end
  end
end
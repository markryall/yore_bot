require 'cinch'
require 'yore_bot/message_store'

module YoreBot
  def execute *args
    Cinch::Bot.new do
      store = MessageStore.new
      nick, server, port, *channels = *args
      configure do |c|
        c.nick = nick
        c.server = server
        c.port = port.to_i
        c.channels = channels
      end

      on(:message, /^#{nick} help$/) do |m|
        m.reply "usage:  /msg #{nick} last 10 (seconds/mins/hours) - channel messages within time period"
        m.reply "code:   https://github.com/markryall/yore_bot"
      end

      on :private, /^last (\d+) s/ do |m, count|
        store.retrieve m, count.to_i
      end

      on :private, /^last (\d+) m/ do |m, count|
        store.retrieve m, count.to_i*60
      end

      on :private, /^last (\d+) h/ do |m, count|
        store.retrieve m, count.to_i*60*60
      end

      on :channel do |m|
        store.store m
      end
    end.start
  end
end

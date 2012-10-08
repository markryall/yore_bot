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

      on(:private, /^last (\d+) s/) { |m, count| store.retrieve m, count.to_i }
      on(:private, /^last (\d+) m/) { |m, count| store.retrieve m, count.to_i*60 }
      on(:private, /^last (\d+) h/) { |m, count| store.retrieve m, count.to_i*60*60 }

      on(:channel) { |m| store.store m }
    end.start
  end
end
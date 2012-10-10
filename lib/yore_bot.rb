require 'cinch'
require 'yore_bot/message_logger'

module YoreBot
  def execute *args
    logger = YoreBot::MessageLogger.new
    Cinch::Bot.new do
      nick, server, port, *channels = *args
      configure do |c|
        c.nick = nick
        c.server = server
        c.port = port.to_i
        c.channels = channels
      end

      on(:catchall) { |m| logger.store m }
    end.start
  end
end
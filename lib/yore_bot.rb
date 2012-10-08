require 'cinch'

module YoreBot
  def execute *args
    messages = []

    Cinch::Bot.new do
      configure do |c|
        c.nick = args.shift
        c.server = args.shift
        c.port = args.shift.to_i
        c.channels = args
      end

      on :private, /^last (\d+)/ do |m, count|
        seconds = count.to_i * 60
        now = Time.now.to_i
        messages.each do |message|
          elapsed = now - message[0]
          m.reply "#{message[1]}: #{message[2]} (#{elapsed}s)" if elapsed < seconds
        end
      end

      on :channel do |m|
        messages << [Time.now.to_i, m.user.nick, m.message]
      end
    end.start
  end
end

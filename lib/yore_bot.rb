require 'cinch'
require 'yore_bot/message_store'

module YoreBot
  def execute *args
    Cinch::Bot.new do
      store = MessageStore.new
      configure do |c|
        c.nick = args.shift
        c.server = args.shift
        c.port = args.shift.to_i
        c.channels = args
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

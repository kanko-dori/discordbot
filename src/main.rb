require 'discordrb'

BOT_TOKEN = ENV['DISCORD_BOT_TOKEN']
BOT_TOKEN.freeze
bot = Discordrb::Commands::CommandBot.new token: BOT_TOKEN, prefix: '!'


bot.command :user do |event|
  # Commands send whatever is returned from the block to the channel. This allows for compact commands like this,
  # but you have to be aware of this so you don't accidentally return something you didn't intend to.
  # To prevent the return value to be sent to the channel, you can just return `nil`.
  event.user.name
end

bot.run

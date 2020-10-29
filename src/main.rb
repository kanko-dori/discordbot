require 'discordrb'
require_relative './lib/idea_manager.rb'

BOT_TOKEN = ENV['DISCORD_BOT_TOKEN']
BOT_TOKEN.freeze
bot = Discordrb::Commands::CommandBot.new token: BOT_TOKEN, prefix: '!'

bot.command :user do |event|
  # Commands send whatever is returned from the block to the channel. This allows for compact commands like this,
  # but you have to be aware of this so you don't accidentally return something you didn't intend to.
  # To prevent the return value to be sent to the channel, you can just return `nil`.
  username = event.user.name

  puts ":user involed: #{username}"
  IdeaManager.hello(username)
end

bot.command :add do |event|
  content = event.message.content.gsub(/!add /, '')

  puts ":add invoked: #{content}"
  IdeaManager.addIdea(content)
end

bot.command :delete do |event|
  content = event.message.content.gsub(/!delete /, '')
  
  puts ":delete invoked: #{content}"
  IdeaManager.deleteIdea(content)
end

bot.command :list do |event|
  puts ':list invoked'

  ideas = IdeaManager.listIdea
  ideas.map do |idea|
    "id: #{idea['id']}, idea: #{idea['idea']}, detail: #{idea['detail']}"
  end
end

bot.run

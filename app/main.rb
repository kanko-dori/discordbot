require 'discordrb'
require 'erb'
require_relative './lib/idea_manager.rb'

BOT_TOKEN = ENV['DISCORD_BOT_TOKEN']
BOT_TOKEN.freeze

db_conf = YAML.load( ERB.new( File.read("./config/database.yml") ).result )
ActiveRecord::Base.establish_connection(db_conf)


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
  name = IdeaManager.addIdea(content)
  "#{name} is added!"
end

bot.command :delete do |event|
  content = event.message.content.gsub(/!delete /, '')
  
  puts ":delete invoked: #{content}"
  name = IdeaManager.deleteIdea(content)
  "#{name} is deleted!"

end

bot.command :last do |event|
  puts ':list invoked'

  idea = IdeaManager.listLastIdea
  "id: #{idea['id']}, name: #{idea['name']}"
end

bot.command :new do |event|
  puts ':new invoked'

  idea = IdeaManager.listIdea
  "id: #{idea['id']}, name: #{idea['name']}"
end

bot.command :list do |event|
  puts ':list invoked'

  idea = IdeaManager.listIdeasAll
  idea.map { |i|
    "id: #{i['id'].to_s}, name: #{i['name']}"
  }
end

bot.run

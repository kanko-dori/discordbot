require 'discordrb'
require 'erb'
require_relative './lib/idea_manager.rb'

BOT_TOKEN = ENV['DISCORD_BOT_TOKEN']
BOT_TOKEN.freeze
ENVIRONMENT = ENV['ENV']
ENVIRONMENT.freeze

db_conf = YAML.load( ERB.new( File.read("./config/database.yml") ).result )
ActiveRecord::Base.establish_connection(db_conf)

p ENV == 'DEVELOPMENT' ? '/' : '!'
bot = Discordrb::Commands::CommandBot.new token: BOT_TOKEN, prefix: ENVIRONMENT.eql?('DEVELOPMENT') ? '/' : '!'

bot.command(:user, descriptipn: 'greet to you!', usage: 'user') do |event|
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
  event.send_embed { |embed|
    embed.title = idea['name']
    # embed.url = "http://example.com/"
    embed.colour = 0xFF8000
    # embed.description = "description"
    embed.add_field(
      name: "id",
      value: idea['id'],
      inline: true
    )
    embed.add_field(
      name: "description",
      value: idea['description'],
      inline: true
    )
  }
end

bot.command :list do |event|
  puts ':list invoked'

  idea = IdeaManager.listIdeasAll
  idea.map { |i|
    "id: #{i['id'].to_s}, name: #{i['name']}"
  }
end

bot.run

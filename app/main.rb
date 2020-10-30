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

bot.command(:add, min_args: 1, max_args: 2, description: 'Add new idea', usage: 'add [idea] [description]') do |event, idea, description|
  puts ":add invoked: #{idea}, #{description}"
  description = '詳細はまだ書かれていません' unless description

  IdeaManager.addIdea(idea, description, event.user.name)
end

bot.command(:edit, min_args: 2, max_args: 2, description: 'edit existing idea', usage: 'exid [idea] [description]') do |event, idea, description|
  puts ":edit invoked: #{idea}, #{description}"
  description = '詳細はまだ書かれていません' unless description

  IdeaManager.updateIdea(idea, description, event.user.name)
end

bot.command(:delete, min_args: 1, max_args: 1, description: 'Delete existing idea', usage: 'delete [idea]') do |event, idea|
  puts ":delete invoked: #{idea} by #{event.user.name}"
  IdeaManager.deleteIdea(idea, event.user.name)
end


bot.command :latest do |event|
  puts ':latest invoked'

  idea = IdeaManager.listIdea
  event.send_embed { |embed|
    embed.title = "最新のアイディア"
    embed.url = "http://example.com/"
    embed.color = 0xFF8000
    embed.description = "description"
    embed.add_field(
      name: "name",
      value: idea['name'],
      inline: true
    )
    embed.add_field(
      name: "description",
      value: idea['description'],
      inline: true
    )
    embed.add_field(
      name: 'author',
      value: idea['author'],
      inline: true
    )
  }
end

bot.command :list do |event|
  puts ':list invoked'

  ideas = IdeaManager.listIdeasAll
  event.send_embed { |embed|
    embed.title = "アイディアリスト"
    # embed.url = "http://example.com/"
    embed.color = 0xFF8000
    embed.description = "登録されているアイディア"
    if ideas.size == 0 then
      embed.add_field(
        name: "error",
        value: '登録されているアイディアはありません',
        inline: false
      )
    else
      ideas.each { |idea|
        p idea['description']
        embed.add_field(
          name: "name",
          value: idea['name'],
          inline: true
        )
        embed.add_field(
          name: "description",
          value: idea['description'],
          inline: true
        )
        embed.add_field(
          name: 'author',
          value: idea['author'],
          inline: true
        )
      }
    end
  }
end

bot.run

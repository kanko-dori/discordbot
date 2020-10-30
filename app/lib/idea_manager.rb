# IdeaManager manage ideas
require 'pg'
require_relative '../models/ideas.rb'

module IdeaManager

  module_function
  def hello(name)
    "Hello, #{name}!"
  end

  def addIdea(idea, description, author)
    p idea, description, author
    begin
      idea = Ideas.new{ |i|
        i.name = idea
        i.description = description
        i.author = author
      }
      idea.save
    rescue ActiveRecord::RecordNotUnique => exception
      return "idea #{idea['name']} is already saved. try `:edit` to change description"
    end
    "#{idea['name']} is added!"
  end
    
    idea['name']
  end

  def deleteIdea(idea)
    idea = Idea.find_by(name: idea)
    idea.delete
    idea
  end

  def listIdea
    ideas = Ideas.first
    p ideas
    ideas
  end


  def listLastIdea
    ideas = Ideas.last
    p ideas
    ideas
  end

  def listIdeasAll
    ideas = Ideas.all
    p ideas
    ideas
  end
end

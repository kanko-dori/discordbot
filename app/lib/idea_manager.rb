# IdeaManager manage ideas
require 'pg'
require_relative '../models/ideas.rb'

module IdeaManager

  module_function
  def hello(name)
    "Hello, #{name}!"
  end

  def addIdea(idea, description, author)
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

  def updateIdea(idea, description, author)
    idea = Ideas.find_by(name: idea)
    if idea['author'].eql?(author) then
      idea.update_column(:description, description)
      "#{idea['name']} is updated."
    else
      "You are not auhor of this idea. Ask #{author} to delete this idea."
    end
  end

  def deleteIdea(idea, author)
    idea = Ideas.find_by(name: idea)
    p idea
    if idea['author'].eql?(author) then
      idea.delete
      "#{idea['name']} is deleted by #{author}"
    else
      "You are not auhor of this idea. Ask #{author} to delete this idea."
    end
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

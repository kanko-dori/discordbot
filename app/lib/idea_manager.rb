# IdeaManager manage ideas
require 'pg'
require_relative '../models/ideas.rb'

module IdeaManager

  module_function
  def hello(name)
    "Hello, #{name}!"
  end

  def addIdea(idea)
    idea = Ideas.new{ |i|
      i.name = idea
      i.description = ''
    }
    idea.save
    
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

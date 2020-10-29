# IdeaManager manage ideas
require 'pg'

module IdeaManager
  def getConnection
    username = ENV['POSTGRES_USER']
    password = ENV['POSTGRES_PASSWORD']
    host = ENV['POSTGRES_HOST']
    database = ENV['POSTGRES_DATABASE']
    port = ENV['POSTGRES_PORT']
    return PG::connect(:host => host, :user => user, :password => password, :dbname => database)
  end

  module_function
  def hello(name)
    "Hello, #{name}!"
  end

  def addIdea(idea)
    username = ENV['POSTGRES_USER']
    password = ENV['POSTGRES_PASSWORD']
    host = ENV['POSTGRES_HOST']
    database = ENV['POSTGRES_DATABASE']
    port = ENV['POSTGRES_PORT']
    conn = PG::connect(:host => host, :user => username, :password => password, :dbname => database)

    sql = "INSERT INTO ideas (idea) VALUES ('#{idea}')"
    conn.exec(sql)
    conn.finish
  end

  def deleteIdea(idea)
    "delete idea: #{idea}"
  end

  def listIdea
    username = ENV['POSTGRES_USER']
    password = ENV['POSTGRES_PASSWORD']
    host = ENV['POSTGRES_HOST']
    database = ENV['POSTGRES_DATABASE']
    port = ENV['POSTGRES_PORT']
    conn = PG::connect(:host => host, :user => username, :password => password, :dbname => database)

    sql = "SELECT * FROM ideas"
    res = conn.exec(sql)
    res.each do |r|
      p r
    end
    res
  end
end

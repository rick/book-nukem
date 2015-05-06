#!/usr/bin/env ruby

require 'koala'
require 'yaml'
require 'pp'
require 'fql'

class Graph
  attr_reader :creds, :access_token, :graph
  def initialize
    @creds = YAML.load(File.read(File.expand_path('~/.facebook.yml')))
    @access_token = creds["access_token"]
    @graph = Koala::Facebook::API.new(access_token)
  end

  def method_missing(meth, *args)
    if graph.respond_to? meth
      graph.send(meth, *args)
    end
  end

  def me
    graph.get_object("me")
  end
end

def fql(query)
  options = { :access_token => Graph.new.access_token }
  Fql.execute({ "query1" => query }, options)
end

likes = fql "select object_id from like where user_id = me() limit 10000000000000"

pp likes
puts likes.size

graph = Graph.new

# delete likes
likes.each do |like|
  puts "deleting like for object [#{like.inspect}]"
  begin
    graph.delete_like(like["object_id"])
  rescue Koala::Facebook::ClientError => e
    puts "Warning: got exception [#{e}].  Continuing..."
  end
end

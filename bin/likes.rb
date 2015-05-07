#!/usr/bin/env ruby

$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), "..", "lib")))

require 'pp'
require 'fql'
require 'graph'

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
    pp [ like["object_id"], graph.get_object(like["object_id"]) ]
    graph.delete_like(like["object_id"])
  rescue Koala::Facebook::ClientError => e
    puts "Warning: got exception [#{e}].  Continuing..."
  end
end

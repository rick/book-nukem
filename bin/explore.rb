#!/usr/bin/env ruby

require 'koala'
require 'yaml'
require 'pp'

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

def display_post(post, post_count)
  likes = post["likes"] ? post["likes"]["data"] : []
  comments = post["comments"] ? post["comments"]["data"] : []
  puts %Q{POST #{post_count}: #{post["created_time"]} [#{post["id"]}] "#{post["description"]}"}
  puts "      #{likes.size} likes, #{comments.size} comments"
  puts
end

def tally_post(post)
  likes = post["likes"] ? post["likes"]["data"] : []
  comments = post["comments"] ? post["comments"]["data"] : []
  [ likes.size, comments.size ]
end

def iterate_over_posts(graph)
  feed = graph.get_connections("me", "feed")
  post_count = likes_count = comments_count = 0
  while feed
    feed.each do |post|
      post_count += 1
      likes, comments = tally_post post
      likes_count += likes
      comments_count += comments

      display_post post, post_count
    end
    feed = feed.next_page
  end

  puts "A total of #{post_count} posts, with #{likes_count} likes and #{comments_count} comments."
end

def iterate_over_likes(graph)
  data = graph.get_connections("me", "likes")
  likes_count = 0
  while data
    data.each do |like|
      likes_count += 1
      pp like
    end
    data = data.next_page
  end
  puts "Total of #{likes_count} likes."
end

def iterate(graph, type)
  data = graph.get_connections("me", type)
  count = 0
  while data
    data.each do |item|
      count += 1
      pp item
    end
    data = data.next_page
  end
  puts %Q{Total of #{count} "#{type}" items.}
end

graph = Graph.new
# iterate_over_posts graph
# iterate_over_likes graph # pages likes

type = ARGV.shift or raise "Usage: #{$0} <type>"
iterate graph, type

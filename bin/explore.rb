#!/usr/bin/env ruby

require 'koala'
require 'yaml'
require 'pp'

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

def initialize_graph
  # read ~/.facebook.yml
  creds = YAML.load(File.read(File.expand_path('~/.facebook.yml')))
  access_token = creds["access_token"]
  graph = Koala::Facebook::API.new(access_token)
end

iterate_over_posts initialize_graph

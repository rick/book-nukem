#!/usr/bin/env ruby

require 'koala'
require 'yaml'
require 'pp'

# read ~/.facebook.yml

creds = YAML.load(File.read(File.expand_path('~/.facebook.yml')))
access_token = creds["access_token"]

graph = Koala::Facebook::API.new(access_token)

me = graph.get_object("me")


feed = graph.get_connections("me", "feed")
while feed
  feed.each do |post|
    pp post
  end
  feed = feed.next_page
  puts "end of page ...\n\n\n"
end

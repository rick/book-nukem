#!/usr/bin/env ruby

$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), "..", "lib")))

require 'pp'
require 'graph'

type = ARGV.shift or raise "Usage: #{$0} <type>"

counter = 0

results = Graph.new.iterate(type) do |item|
  puts "I found one!"
  counter += 1
  break if counter > 5
end

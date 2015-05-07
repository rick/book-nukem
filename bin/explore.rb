#!/usr/bin/env ruby

$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), "..", "lib")))

require 'pp'
require 'graph'
require 'commander/import'

program :version, '0.0.1'
program :description, 'explore or delete facebook data'

command :list do |c|
  c.syntax = ' list <type>'
  c.summary = 'list objects of a certain type, e.g., "posts", "inbox", ...'
  c.description = 'This will list all instances of a given type of object'

  c.option '--max COUNT', Integer, "Maximum number of records to output"

  c.example 'showing posts', %Q|
    $ bundle exec ruby bin/explore.rb list posts
    {"id"=>"123456609586309540",
     "from"=>{"id"=>"349853749583749", "name"=>"Rick Bradley"},
     "message"=>
      "> Three-year program, Journey to Social Inclusion, led to 75% of participants staying in stable housing, and an 80% drop in need for health services"
      # ...
  |

  c.action do |args, options|
    type = args.shift or raise "a type is required. See --help"

    counter = 0
    results = Graph.new.iterate(type) do |item|
      pp item
      counter += 1
      break if options.max && counter >= options.max
    end
  end
end

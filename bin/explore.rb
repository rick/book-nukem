#!/usr/bin/env ruby

$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), "..", "lib")))

require 'pp'
require 'graph'

type = ARGV.shift or raise "Usage: #{$0} <type>"
Graph.new.iterate type

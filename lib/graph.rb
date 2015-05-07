require 'koala'
require 'yaml'

# A wrapper around Koala::Facebook::API, which handles reading credentials,
# setting up the graph instance, and providing some simple convenience methods.
class Graph

  attr_reader :creds, :access_token, :graph

  # read credentials from ~/.facebook.yml, save them, initialize
  # a Koala::Facebook::API instance.
  def initialize
    @creds = YAML.load(File.read(File.expand_path('~/.facebook.yml')))
    @access_token = creds["access_token"]
    @graph = Koala::Facebook::API.new(access_token)
  end

  # iterate over a type of connected object
  #   e.g., "posts", "inbox", "outbox", ...
  #
  # if no block is given, simply outputs (via `pp`) each object,
  # if a block is given, calls the block on each object
  #
  # returns the list of all found objects
  def iterate(type, &block)
    data = graph.get_connections("me", type)
    count = 0
    while data
      results = data.inject([]) do |list, item|
        if block_given?
          yield(item)
        else
          pp item
        end

        list << item
      end
      data = data.next_page
    end

    results
  end

  # quick shorthand to get the user's object
  def me
    graph.get_object("me")
  end

  # delegate any stray calls to the Koala::Facebook::API instance
  def method_missing(meth, *args)
    if graph.respond_to? meth
      graph.send(meth, *args)
    end
  end
end

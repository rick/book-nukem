require 'koala'
require 'yaml'

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

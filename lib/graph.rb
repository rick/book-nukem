require 'koala'
require 'yaml'

class Graph
  attr_reader :creds, :access_token, :graph
  def initialize
    @creds = YAML.load(File.read(File.expand_path('~/.facebook.yml')))
    @access_token = creds["access_token"]
    @graph = Koala::Facebook::API.new(access_token)
  end

  def iterate(type)
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

  def method_missing(meth, *args)
    if graph.respond_to? meth
      graph.send(meth, *args)
    end
  end

  def me
    graph.get_object("me")
  end
end

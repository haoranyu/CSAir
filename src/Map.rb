require 'src/Graph'
class Map < Graph
  
  require 'json'
  
  alias add_metro add_node
  alias remove_metro remove_node
  alias update_metro update_node
  alias get_metro get_node
  alias exist_metros exist_nodes
  alias remove_route remove_edge
  alias update_route update_edge
  alias get_route get_edge
  
  def initialize(filename)
    file = JSON.parse(IO.read(filename))
    @nodes = Hash.new
    @edges = Hash.new
    initialize_metros(file['metros'])
    initialize_routes(file['routes'])
  end
  
  def initialize_metros(metros)
    metros.each do |metro|
      self.add_metro(metro['code'], metro)
    end
  end
  
  def initialize_routes(routes)
    routes.each do |route|
      self.add_route(route['ports'][0], route['ports'][1], route['distance'])
    end
  end
  
  def add_route(metro1, metro2, value)
    self.add_edge(metro1, metro2, value)
    self.add_edge(metro2, metro1, value)
  end
  
  def metros
    @nodes
  end
  
  def routes
    @edges
  end
end
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
  
  # Constructor for Map
  def initialize(filename)
    file = JSON.parse(IO.read(filename))
    @nodes = Hash.new
    @edges = Hash.new
    initialize_metros(file['metros'])
    initialize_routes(file['routes'])
  end
  
  ##
  # Add metros to the map
  # 
  # @param [Array, #metros] the array of metros information
  def initialize_metros(metros)
    metros.each do |metro|
      metro['flight_to'] = Array.new
      self.add_metro(metro['code'], metro)
    end
  end
  
  ##
  # Add routes to the map
  # 
  # @param [Array, #routes] the array of routes information
  def initialize_routes(routes)
    routes.each do |route|
      self.add_route(route['ports'][0], route['ports'][1], route['distance'])
      self.add_route(route['ports'][1], route['ports'][0], route['distance'])
    end
  end
  
  ##
  # Add a route to the map
  # 
  # @param [String, #metro1] the abbreviation of starting matro
  # @param [String, #metro2] the abbreviation of ending matro
  # @param [Integer, #distance] the distance between two metros
  def add_route(metro1, metro2, distance)
    self.add_edge(metro1, metro2, distance)
    @nodes[metro1]['flight_to'].push(metro2)
  end
  
  # Return all metro objects
  def metros
    @nodes
  end
  
  # Return all route objects
  def routes
    @edges
  end
  
  #  Edit attribute of a metro
  def update_metro_attibute(metro, attibute, new_value)
    case attibute
    when 'code', 'name', 'country', 'continent', 'timezone', 'coordinates', 'region'
      @nodes[metro][attibute] = new_value
    when 'population'
      if new_value >= 0
        @nodes[metro][attibute] = new_value
      else
        puts "Error: population can not be negative"
      end
    end
  end
end
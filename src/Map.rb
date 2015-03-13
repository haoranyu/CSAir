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
  alias exist_route exist_edge
  
  # Constructor for Map
  def initialize(filename)
    file = JSON.parse(IO.read(filename))
    @nodes = Hash.new
    @edges = Hash.new
    initialize_metros(file['metros'])
    initialize_routes(file['routes'])
    @data_source = file['data sources']
  end
  
  # Merge a json file for a new map into the old one
  def merge(filename)
    file = JSON.parse(IO.read(filename))
    initialize_metros(file['metros'])
    initialize_routes(file['routes'])
    @data_source = @data_source | file['data sources']
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
    if exist_nodes([metro1, metro2])
      self.add_edge(metro1, metro2, distance)
      @nodes[metro1]['flight_to'].push(metro2)
    end
  end
  
  # Return all metro objects
  def metros
    return @nodes
  end
  
  # Return all route objects
  def routes
    return @edges
  end
  
  # Return all data source
  def data_source
    return @data_source
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
  
  # Using json to encode the map
  def json_encode_map
    map = Hash.new
    map['data source'] = @data_source
    map['metros'] = json_encode_metros
    map['routes'] = json_encode_routes
    return map.to_json
  end
  
  # Obtain the array of metros for json to encode
  def json_encode_metros
    metros_array = []
    @nodes.each do |key, value|
      metros_array.push(value)
    end
    return metros_array
  end
  
  # Obtain the array of routes for json to encode
  def json_encode_routes
     routes_array = []
     @edges.each do |key, value|
       route = Hash.new
       route['ports'] = key
       route['distance'] = value
       routes_array.push(route)
     end
     return routes_array
   end
   
   # Output a json map to the disk
   def output_json_map
     IO.write("data/map_data_output.json", json_encode_map)
   end
   
  def get_shorest_path(metro1, metro2)
    distance = Hash.new # vertex - dist
    previous = Hash.new
    frontier = Hash.new
    
    @nodes.each do |key, value|
      if key != metro1
        distance[key] = Float::INFINITY
      else
        distance[metro1] = 0
      end
      previous[key] = nil
      frontier[key] = distance[key]
    end

    while not frontier.empty?
      u = frontier.min_by{|key, value| value}
      frontier.delete(u[0])
      if u[0] == metro2
        break
      end
      
      self.get_node(u[0])['flight_to'].each do |v|
        alt = distance[u[0]] + self.get_route(u[0], v)
        if alt < distance[v]
          distance[v] = alt
          previous[v] = u[0]
        end
      end
    end
    
    current_metro = metro2
    expect_route = []
    while current_metro != nil
      expect_route.insert(0, current_metro)
      current_metro = previous[current_metro]
    end
    return expect_route
  end
  
  
end
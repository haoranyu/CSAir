class Info
  
  # Constructor for Info
  def initialize(map)
    @map = map
  end

  ##
  # Use to accept and process queries
  # 
  # @param [String, #query] the query from user
  def query(query)
    case query[0]
      when 'list'
        print_metro_list
      when 'metro'
        print_metro_info(query[1])
      when 'statistic'
        print_statistics
      when 'map'
        print_map
      when 'remove'
        if query[2] == nil
          @map.remove_metro(query[1])
        else
          @map.remove_route(query[1], query[2])
        end
      when 'add'
        if query[2] == nil
          @map.add_metro(query[1])
        else
          @map.add_route(query[1], query[2])
        end
      when 'edit'
        @map.update_metro_attibute(query[1], query[2], query[3])
      when 'route'
        print_route_info(query)
      when 'path'
        print_path_info(query[1], query[2])
      else
        puts "You have to follow the instruction"
    end
  end
  
  # List all metros' information
  def print_metro_list
    puts "<code>\t<name>"
    @map.metros.each do |metro|
      puts metro[1]['code'] << "\t" << metro[1]['name']
    end
  end
  
  ##  
  # Get information for specified metro
  # 
  # @param [String, #code] the code of the metro from query
  def print_metro_info(code)
    if @map.exist_metros([code])
      metro = @map.get_metro(code)
      puts "==== " << metro['name'] << '(' << metro['code'] << ') ===='
      puts "code: " << metro['code']
      puts "name: " << metro['name']
      puts "country: " << metro['country']
      puts "continent: " << metro['continent']
      puts "timezone: " << metro['timezone'].to_s
      puts "latitude and longitude are"
      metro['coordinates'].each {|key, value| puts "  #{key} #{value}" }
  
      puts "population: " << metro['population'].to_s
      puts "region: " << metro['region'].to_s
    else
      puts code << " is not found"
    end
  end
  
  # Output all statistic information
  def print_statistics()
    puts '==== Statistic ===='
    puts 'longest single flight: ' << statistic_longest_flight
    puts 'shortest single flight: ' << statistic_shortest_flight
    puts 'average distance: ' << statistic_average_distance
    puts 'biggest city: ' << statistic_biggest_city
    puts 'smallest city: ' << statistic_smallest_city
    puts 'average population: ' << statistic_average_population
    puts 'continents served: '
    statistic_continents
    puts 'hub city: ' << statistic_hub_city
  end
  
  ## 
  # Return the longest single flight in the network
  #
  # @return [String] the longest single flight in the network
  def statistic_longest_flight
    max = @map.routes.max_by{|key, value| value}
    return 'between ' << max[0][0] << ' and ' << max[0][1].dup << ' - with distance ' << max[1].to_s
  end
  
  ##
  # Return the shortest single flight in the network
  #
  # @return [String] the shortest single flight in the network
  def statistic_shortest_flight
    min = @map.routes.min_by{|key, value| value}
    return 'between ' << min[0][0] << ' and ' << min[0][1].dup << ' - with distance ' << min[1].to_s
  end
  
  ##
  # Return the average distance of all the flights in the network
  #
  # @return [String] the average distance of all the flights in the network
  def statistic_average_distance
    sum = 0
    @map.routes.each do |key, value|
      sum += value
    end
    return (sum / @map.routes.length).to_s
  end
  
  ##
  # Return the biggest city (by population) served by CSAir
  #
  # @return [String] the biggest city (by population) served by CSAir
  def statistic_biggest_city
    max = @map.metros.max_by{|key, value| value['population']}
    return max[1]['name'].dup << ' - with population ' << max[1]['population'].to_s
  end
  
  ##
  # Return the smallest city (by population) served by CSAir
  #
  # @return [String] the smallest city (by population) served by CSAir
  def statistic_smallest_city
    min = @map.metros.min_by{|key, value| value['population']}
    return min[1]['name'].dup << ' - with population ' << min[1]['population'].to_s
  end
  
  ##
  # Return the average size (by population) of all the cities served by CSAir
  #
  # @return [String] the average size (by population) of all the cities served by CSAir
  def statistic_average_population
    sum = 0
    @map.metros.each do |key, value|
      sum += value['population']
    end
    return (sum / @map.metros.length).to_s
  end

  # Print a list of the continents served by CSAir and which cities are in them
  def statistic_continents
    continents = Hash.new
    
    @map.metros.each do |key, value|
      if continents.has_key?(value['continent'])
        continents[value['continent']].push(value)
      else
        continents[value['continent']] = Array.new
        continents[value['continent']].push(value)
      end
    end
    
    continents.each do |key, value|
      puts '  ' << key << ':'
      value.each do |city|
        puts '    ' << city['name']
      end
    end
  end
  
  ##
  # Identifying CSAir's hub cities – the cities that have the most direct connections.
  #
  # @return [String] the cities that have the most direct connections.
  def statistic_hub_city
    max = @map.metros.max_by{|key, value| value['flight_to'].length}
    return max[1]['name']<< ' - with number of direct connections ' << max[1]['flight_to'].length.to_s
  end
  
  # Show the routes map
  def print_map
    routes = Array.new
    @map.routes.each do |key, value|
      routes.push(key.join('-'))
    end
    puts 'Check map at: http://www.gcmap.com/map?P=' << routes.join(',') << '&MS=wls&MR=800&MX=800x800&PM=*'
  end
  
  # Respond to the information of the route
  def print_route_info(query)
    metro_list = []
    query.shift
    
    begin
       metro = query.shift
       if metro != nil
         metro_list.push(metro)
       end
    end until metro == nil
    
    route_information(metro_list)
  end
  
  # List distance / cost / time information about a route 
  def route_information(metro_list)
    if is_route(metro_list)
      puts "The total distance of this route is: " << self.get_route_distance(metro_list).to_s()
      puts "The total cost of this route is: " << self.get_route_cost(metro_list).to_s()
      puts "The total time of this route is: " << self.get_route_time(metro_list).to_s()
    else
      puts "Error: There is no such route possible"
      return false
    end
  end
  
  # Judge the route is legal or not
  def is_route(metro_list)
    metro_list.each_cons(2) do |metro1, metro2|
      if not @map.exist_route(metro1, metro2)
        return false
      end
    end
    return true
  end
  
  # Get the total distance of a route
  def get_route_distance(metro_list)
    distance_sum = 0
    metro_list.each_cons(2) do |metro1, metro2|
      distance_sum += @map.get_route(metro1, metro2)
    end
    return distance_sum
  end

  # Get the total cost of a route  
  def get_route_cost(metro_list)
    unit_cost = 0.35
    cost_sum = 0
    
    metro_list.each_cons(2) do |metro1, metro2|
      cost_sum += unit_cost * @map.get_route(metro1, metro2)
      unit_cost -= 0.05
      if unit_cost < 0
        unit_cost = 0
      end
    end
    return cost_sum
  end
  
  # Get the total time of a route  
  def get_route_time(metro_list)
    return self.get_route_layover_time(metro_list) + self.get_route_flying_time(metro_list)
  end

  # Get the layover time of a route    
  def get_route_layover_time(metro_list)
    time_sum = 0
    metro_list.each do |metro|
      time = 2 - (1 / 6) * @map.get_metro(metro)['flight_to'].length
      if time < 0
        time = 0
      end
      time_sum += time
    end
    return time_sum
  end
  
  # Get the flying time of a route    
  def get_route_flying_time(metro_list)
    time_sum = 0
    metro_list.each_cons(2) do |metro1, metro2|
      flight_distance = @map.get_route(metro1, metro2)
      if flight_distance > 400
        time = (flight_distance + 400) / 750
      else
        time = sqrt(flight_distance) / 37.5
      end
      time_sum += time
    end
    return time_sum
  end
  
  def print_path_info(metro1, metro2)
    route_information(@map.get_shorest_path(metro1, metro2))
  end
end

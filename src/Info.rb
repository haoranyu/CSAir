class Info
  def initialize(map)
    @map = map
  end
  
  def query(query)
    case query[0]
      when 'list'
        list
      when 'metro'
        metro(query[1])
      when 'statistic'
        statistic
      else
        puts "You have to follow the instruction"
    end
  end
  
  def list
    puts "<code>\t<name>"
    @map.metros.each do |metro|
      puts metro[1]['code'] << "\t" << metro[1]['name']
    end
  end
  
  def metro(code)
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
  
  def statistic()
    puts '==== Statistic ===='
    puts 'longest single flight: ' << statistic_longest
    puts 'shortest single flight: ' << statistic_shortest
    puts 'average distance: ' << statistic_average_distance
    puts 'biggest city: ' << statistic_biggest_city
    puts 'smallest city: ' << statistic_smallest_city
    puts 'average population: ' << statistic_average_population
    puts 'continents served: '
    statistic_continents
    puts 'hub city: ' << statistic_sub_city
  end
  
  def statistic_longest
    max = @map.routes.max_by{|key, value| value}
    return 'between ' << max[0][0] << ' and ' << max[0][1].dup << ' - with distance ' << max[1].to_s
  end
  
  def statistic_shortest
    min = @map.routes.min_by{|key, value| value}
    return 'between ' << min[0][0] << ' and ' << min[0][1].dup << ' - with distance ' << min[1].to_s
  end
  
  def statistic_average_distance
    sum = 0
    @map.routes.each do |key, value|
      sum += value
    end
    return (sum / @map.routes.length).to_s
  end
  
  def statistic_biggest_city
    max = @map.metros.max_by{|key, value| value['population']}
    return max[1]['name'].dup << ' - with population ' << max[1]['population'].to_s
  end
  
  def statistic_smallest_city
    min = @map.metros.min_by{|key, value| value['population']}
    return min[1]['name'].dup << ' - with population ' << min[1]['population'].to_s
  end
  
  def statistic_average_population
    sum = 0
    @map.metros.each do |key, value|
      sum += value['population']
    end
    return (sum / @map.metros.length).to_s
  end
  
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
  
  def statistic_sub_city
    max = @map.metros.max_by{|key, value| value['flight_to'].length}
    return max[1]['name']<< ' - with number of direct connections ' << max[1]['flight_to'].length.to_s
  end
end
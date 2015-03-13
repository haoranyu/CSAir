require 'json'
require 'src/Map'
require 'src/Info'

puts "Please enter the query:"
puts "list            #List of all the cities that CSAir flies to"
puts "metro <code>    #Specific information about a specific city"
puts "statistic       #Show all statistic informations"
puts "map             #Show the route map"

map = Map.new('data/map_data.json')
info = Info.new(map)
map.output_json_map()
while true
  puts "-------- PLEASE QUERY --------"
  query = gets.split(' ')
  info.query(query)
end
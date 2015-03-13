require 'json'
require 'src/Map'
require 'src/Info'

puts "Please enter the query:"
puts "list                        #List of all the cities that CSAir flies to"
puts "metro <code>                #Specific information about a specific city"
puts "statistic                   #Show all statistic informations"
puts "map                         #Show the route map"
puts "remove <metro>              #Remove metro"
puts "remove <metro1> <metro2>    #Remove route"
puts "add <metro_info_in_json>    #Add metro"
puts "add <metro1> <metro2>       #Add route"
puts "edit <metro> <attr> <value> #Edit an attribute in a metro with the value"
puts "route <metro1> <2> ... <n>  #Display the route info"
puts "path <metro1> <metro2>      #Display the route info for path from metro1 to metro2"
map = Map.new('data/map_data.json')
info = Info.new(map)

while true
  puts "-------- PLEASE QUERY --------"
  query = gets.split(' ')
  info.query(query)
end
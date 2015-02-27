require 'json'
require 'src/Map'
require 'src/Info'

puts "Please enter the query:"
puts "list            #List of all the cities that CSAir flies to"
puts "metro <code>    #Specific information about a specific city"
puts "statistic       #Show all statistic informations"
puts "map             #Show the route map"
puts "-------- PLEASE QUERY --------"

while true
  query = gets.split(' ')
  map = Map.new('data/map_data.json')
  info = Info.new(map)
  info.query(query)
end
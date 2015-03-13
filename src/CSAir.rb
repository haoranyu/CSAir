require 'json'
require 'src/Map'
require 'src/Info'

puts "Please enter the query:"
puts "list            #List of all the cities that CSAir flies to"
puts "metro <code>    #Specific information about a specific city"
puts "statistic       #Show all statistic informations"
puts "map             #Show the route map"
puts "-------- PLEASE QUERY --------"

map = Map.new('data/map_data.json')
info = Info.new(map)

while true
  query = gets.split(' ')
  info.query(query)
end
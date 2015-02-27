require 'json'
require 'src/Map'

@graph = Map.new('data/map_data.json')
puts(@graph.metros)
puts(@graph.routes)
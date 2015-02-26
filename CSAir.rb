require 'json'
require 'Graph'



x = Graph.new
x.addNode('x',100)
x.addNode('y',100)
puts(x.addEdge("x", "y",100))
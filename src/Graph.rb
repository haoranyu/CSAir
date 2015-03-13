class Graph
  
  # Constructor for Graph
  def initialize()
    @nodes = Hash.new
    @edges = Hash.new
  end
  
  ##
  # Add a node to the graph
  # 
  # @param [Object, #key] node key
  # @param [Object, #value] node value
  def add_node(key, value)
    @nodes[key] = value
  end
  
  ##
  # Remove a node by key
  # and it will also remove edge with an end on it
  # 
  # @param [Object, #key] node key
  # @param [Object, #value] node value
  def remove_node(key)
    @nodes.delete(key)
    @edges.each do |edge_key, edge_value|
      if edge_key.include?(key)
        @edges.delete(edge_key)
      end
    end
  end

  ##
  # Update a node with key to the new value
  # 
  # @param [Object, #key] node key
  # @param [Object, #value] node value 
  def update_node(key, value)
    remove_node(key)
    add_node(key, value)
  end

  ##
  # Get a node by key
  # 
  # @param [Object, #key] node key
  def get_node(key)
    return @nodes[key]
  end
  
  ##
  # Add a node to the graph
  # 
  # @param [Object, #key] contents the contents to reverse 
  # @param [Object, #value] contents the contents to reverse 
  # @return [Boolean] whether these keys have nodes in the graph
  def exist_nodes(key_arr)
    key_arr.each do |key|
      if not @nodes.has_key?(key)
        return false
      end
    end
    return true
  end
  
  ##
  # Add an edge to the value
  # 
  # @param [Object, #node_from_key] the from node key  
  # @param [Object, #node_to_key] the to node key 
  # @param [Object, #value] edge value set
  def add_edge(node_from_key, node_to_key, value)
    edge_key = [node_from_key, node_to_key]
    if self.exist_nodes(edge_key)
      @edges[edge_key] = value
    else
      return false
    end
  end

  ##
  # Remove an edge by from_key and to_key
  # 
  # @param [Object, #node_from_key] the from node key  
  # @param [Object, #node_to_key] the to node key 
  def remove_edge(node_from_key, node_to_key)
    edge_key = [node_from_key, node_to_key]
    @edges.delete(edge_key)
  end
  
  ##
  # Update an edge to the new value
  # 
  # @param [Object, #node_from_key] the from node key  
  # @param [Object, #node_to_key] the to node key 
  # @param [Object, #value] edge value set
  def update_edge(node_from_key, node_to_key, value)
    remove_edge(node_from_key, node_to_key)
    add_edge(node_from_key, node_to_key, value)
  end

  ##
  # Get a edge by from_key and to_key
  # 
  # @param [Object, #node_from_key] the from node key  
  # @param [Object, #node_to_key] the to node key 
  def get_edge(node_from_key, node_to_key)
    edge_key = [node_from_key, node_to_key]
    return @edges[edge_key]
  end
  
  ##
  # Exist edge
  # 
  # @param [Object, #node_from_key] the from node key  
  # @param [Object, #node_to_key] the to node key 
  def exist_edge(node_from_key, node_to_key)
    return (get_edge(node_from_key, node_to_key) != nil)
  end
  
  # Clear every thing in the graph
  def clear()
    @edges.clear
    @nodes.clear
  end
  
  ##
  # Exist edge
  # 
  # @param [String, #s] the start vertex
  # @param [String, #t] the terminal vertex
  def dijkstra(s, t)
    distance = Hash.new
    previous = Hash.new
    frontier = Hash.new
    
    @nodes.each do |key, value|
      if key != s
        distance[key] = Float::INFINITY
      else
        distance[s] = 0
      end
      previous[key] = nil
      frontier[key] = distance[key]
    end

    while not frontier.empty?
      u = frontier.min_by{|key, value| value}
      frontier.delete(u[0])
      if u[0] == t
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
    return previous
  end
end


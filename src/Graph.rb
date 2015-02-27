class Graph
  def initialize()
    @nodes = Hash.new
    @edges = Hash.new
  end
  
  def add_node(key, value)
    @nodes[key] = value
  end
  
  def remove_node(key)
    @nodes.delete(key)
  end
  
  def update_node(key, value)
    remove_node(key)
    add_node(key, value)
  end
  
  def get_node(key)
    return @nodes[key]
  end
  
  def exist_nodes(key_arr)
    key_arr.each do |key|
      if not @nodes.has_key?(key)
        return false
      end
    end
    return true
  end
  
  def add_edge(node_from_key, node_to_key, value)
    edge_key = [node_from_key, node_to_key]
    if self.exist_nodes(edge_key)
      @edges[edge_key] = value
    else
      return false
    end
  end
  
  def remove_edge(node_from_key, node_to_key)
    edge_key = [node_from_key, node_to_key]
    @edges.delete(edge_key)
  end
  
  def update_edge(node_from_key, node_to_key, value)
    remove_edge(node_from_key, node_to_key)
    add_edge(node_from_key, node_to_key, value)
  end
  
  def get_edge(node_from_key, node_to_key)
    edge_key = [node_from_key, node_to_key]
    return @edges[edge_key]
  end
  
  def clear()
    @edges.clear
    @nodes.clear
  end
end


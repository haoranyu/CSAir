class Graph
  def initialize()
    @nodes = Hash.new
    @edges = Hash.new
  end
  
  def addNode(key, value)
    @nodes[key] = value
  end
  
  def removeNode(key)
    @nodes.delete(key)
  end
  
  def updateNode(key, value)
    removeNode(key)
    addNode(key, value)
  end
  
  def getNode(key)
    return @nodes[key]
  end
  
  def existNodes(keyArray)
    keyArray.each do |key|
      if not @nodes.has_key?(key)
        return false
      end
    end
    return true
  end
  
  def addEdge(nodeFromKey, nodeToKey, value)
    edgeKey = [nodeFromKey, nodeToKey]
    if self.existNodes(edgeKey)
      @edges[edgeKey] = value
    else
      return false
    end
  end
  
  def removeEdge(nodeFromKey, nodeToKey)
    edgeKey = [nodeFromKey, nodeToKey]
    @nodes.delete(edgeKey)
  end
  
  def updateEdge(nodeFromKey, nodeToKey, value)
    removeEdge(nodeFromKey, nodeToKey)
    addEdge(nodeFromKey, nodeToKey, value)
  end
end


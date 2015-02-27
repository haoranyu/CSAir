require 'test/unit'
require './src/Graph'
require './src/Map'

class TEST_Main < Test::Unit::TestCase
  # Test set up
  def setup
    @graph = Graph.new();
    @graph.add_node('a', 100);
    @graph.add_node('b', 500);
  end
  
  # Test graph nodes insertion
  def test_insert_nodes
    @graph.add_node('x', 200);
    @graph.add_node('y', 300);
    assert_equal(true, @graph.exist_nodes(['x']));
    assert_equal(true, @graph.exist_nodes(['y']));
    assert_equal(true, @graph.exist_nodes(['x','y']));
    assert_equal(200, @graph.get_node('x'));
    assert_equal(300, @graph.get_node('y'));
  end
  
  # Test graph edges insertion
  def test_insert_edges
    @graph.add_edge('a', 'b', 100);
    assert_equal(100, @graph.get_edge('a', 'b'));
  end
  
  # Test loading a map
  def test_load_map
    @map = Map.new('data/map_data.json')
    assert_equal('Santiago', @map.get_metro('SCL')['name']);
    assert_equal(2425, @map.get_route('BOG', 'MIA'));
  end
end
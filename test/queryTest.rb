require 'test/unit'
require './src/Graph'
require './src/Map'
require './src/Info'

class TEST_Main < Test::Unit::TestCase
  # Test set up
  def setup
    @map = Map.new('data/map_data.json')
    @info = Info.new(@map)
  end
  
  # Test statistic_longest_flight
  def test_longest_flight
    assert_equal("between SYD and LAX - with distance 12051", @info.statistic_longest_flight())
  end
  
  # Test statistic_shortest_flight
  def test_shortest_flight
    assert_equal("between WAS and NYC - with distance 334", @info.statistic_shortest_flight())
  end
  
  # Test statistic_average_distance
  def test_average_distance
    assert_equal("2300", @info.statistic_average_distance())
  end
  
  # Test statistic_biggest_city
  def test_biggest_city
    assert_equal("Tokyo - with population 34000000", @info.statistic_biggest_city())
  end
  
  # Test statistic_smallest_city
  def test_smallest_city
    assert_equal("Essen - with population 589900", @info.statistic_smallest_city())
  end
  
  # Test statistic_average_population
  def test_average_population
    assert_equal("11796143", @info.statistic_average_population())
  end
  
  # Test statistic_hub_city
  def test_hub_city
    assert_equal("Istanbul - with number of direct connections 6", @info.statistic_hub_city())
  end
  
  def test_is_route
    assert_equal(true, @info.is_route(["MNL", "SFO", "CHI"]))
  end
  
  def test_route_distance
    assert_equal(14238, @info.get_route_distance(["MNL", "SFO", "CHI"]))
  end
  
  def test_route_cost
    assert_equal(4833.599999999999, @info.get_route_cost(["MNL", "SFO", "CHI"]))
  end
  
  def test_route_flying_time
    assert_equal(19, @info.get_route_flying_time(["MNL", "SFO", "CHI"]))
  end
  
  def test_route_layover_time
    assert_equal(6, @info.get_route_layover_time(["MNL", "SFO", "CHI"]))
  end
  
  def test_route_time
    assert_equal(25, @info.get_route_time(["MNL", "SFO", "CHI"]))
  end
end

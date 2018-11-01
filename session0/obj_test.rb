require 'test/unit'
class Obj
  attr_accessor :x
 
  def initialize(x)
    @x = x
  end
end

class TestObj < Test::Unit::TestCase
  def test_gen
    a = Obj.new(5)
    refute_nil(a)
    assert_equal(5,a.x)
  end
end 
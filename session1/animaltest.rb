require 'test/unit'
require './animal.rb'


##
# A class for doing unit test assertions on
# the animal class
#
 
class AnimalTest < Test::Unit::TestCase

    def setup
	    @a =  Animal.new("Dog.1","dog food","bowl")
			@b = Dog.new()
    end
   
    def testattributes
=begin
# Testing the Animal class
=end
       assert_equal('Dog.1',@a.name)
       assert_equal('dog food',@a.foodType)
       assert_equal('bowl',@a.waterContainer)
       assert_equal(Time.new(0),@a.lastFed)
       assert_equal(Time.new(0),@a.lastWatered)

=begin
# Testing the Dog sub class
=end
       assert_equal('Fido.1',@b.name)
       assert_equal('dog food',@b.foodType)
       assert_equal('dish',@b.waterContainer)
       assert_equal(Time.new(0),@b.lastFed)
       assert_equal(Time.new(0),@b.lastWatered)

		end

    def testfeeding       
       assert(!@a.fed?)
       @a.feed
       assert_not_equal(Time.new(0),@a.lastFed)
       assert(@a.fed?)
    end

    def testwatering
       assert(! @a.watered?)
       @a.water
       assert_not_equal(Time.new(0),@a.lastWatered)
       assert(@a.watered?)
   end

end
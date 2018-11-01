require 'profiler'
require_relative './animal.rb'

animals = []

class Cat < Animal
  def initialize (name="Fluffy")
	  super(name,"fish","bowl")
	end
end

class Dog < Animal
	def initialize (name = "Fido")
	  super(name,"dog food","dish")
	end
end

class Elephant < Animal
	def initialize (name="Jumbo")
	  super(name,"bananas","tub")
	end
end

animalType = [:Cat,:Dog,:Elephant]

Profiler__::start_profile

puts "Setup ======================"

tally = Hash.new

10.times do
  a = animalType[rand(animalType.length)]	
  animals << eval("#{a}.new('#{a}.#{animals.length + 1}')")
  if tally[animals.last.class].nil?
	  tally[animals.last.class] = [0,0,0,0,0]
		print tally.inspect
	end
	tally[animals.last.class][0] = tally[animals.last.class][0] + 1
end

puts "Feeding/Watering ============="
animals.length.times do |i|
	animals[rand(animals.length)].feed
	animals[rand(animals.length)].water
end

puts "Tally ============================================"

animals.each do |a|
  if a.fed?
	  tally[a.class][1] += 1
	else
	  tally[a.class][2] += 1
	end

  if a.watered?
	  tally[a.class][3] += 1
	else
	  tally[a.class][4] += 1
	end	
end

puts " Class     | Total   | Fed?        | Watered?   |"
puts " Name      | Number  | Yes    No   | Yes     No |"
puts "===========+=========+=============+=============+"

tally.keys.each do |k|
  puts "%10s | %7i | %5i %5i | %5i %5i |" % ([k, tally[k]]).flatten!
end

puts "===========+=========+=============+=============+"



puts "=============================="

animals.each do |a|
 puts a.status
end




Profiler__::stop_profile
Profiler__::print_profile(STDOUT)

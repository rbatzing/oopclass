class Animal
   attr_accessor :name, :foodType, :waterContainer,
      :lastFed, :lastWatered
   
   def initialize(name,food,waterContainer)
      @name = name
      @foodType = food
      @waterContainer = waterContainer
      @lastFed = Time.new(0)
      @lastWatered = Time.new(0)
      print "#{Time.now}: Added new animal: "
      puts self
   end
   
   def water()
      @lastWatered = Time.now
      print "#{@lastWatered}: "
      print "Gave #{@name} water "
      puts "in a #{@waterContainer}"
   end
   
   def feed()
      @lastFed = Time.now
      print "#{@lastFed}: "
      print "Gave #{@name} some #{@foodType}"
      puts " to eat"
   end
   
   def fed?()
      return ((Time.now - @lastFed) < 24 *3600)
   end
   
   def watered?()
      return ((Time.now - @lastWatered) < 24 *3600)
   end
   
   def to_s()
      "#{@name} eats #{@foodType}, " +
          "drinks from a #{@waterContainer}" 
   end

   def status()
      stat = "#{Time.now}: #{@name} "
      if (fed?())
         stat <<  "has been fed, " 
      else
         stat <<  "is very hungry, "
      end

      if (watered?())
         stat << " has been watered."
      else
         stat << " is very thirsty."
      end
      return(stat)
   end
end

=begin
Subclasses of Animals
=end

class Cat < Animal
  @@count = 1

  def initialize(name="Fluffy")
	  super(name + "." + @@count.to_s,"fish","bowl")
		@@count += 1
	end
end

class Dog < Animal
  @@count = 1

	def initialize (name = "Fido")
	  super(name + "." + @@count.to_s,"dog food","dish")
		@@count += 1
	end
end

class Elephant < Animal
  @@count = 1
	
	def initialize (name="Jumbo")
	  super(name + "." + @@count.to_s,"bananas","tub")
		@@count += 1
	end
end


if __FILE__ == $0
cat =Animal.new("Fluffy","fish","dish");
puts cat.status
cat.foodType
puts cat.status
cat.water
puts cat.status

dog = Animal.new("Spot","dog food","bowl");
puts dog.status
end

=begin
Fluffy eats fish, drinks from a dish
2012-11-16 01:33:05 +0700: Fluffy is very hungry,  is very thirsty.
2012-11-16 01:33:05 +0700: Gave Fluffy some fish to eat
2012-11-16 01:33:05 +0700: Fluffy has been fed,  is very thirsty.
2012-11-16 01:33:05 +0700: Gave Fluffy water in a dish
2012-11-16 01:33:05 +0700: Fluffy has been fed,  has been watered.
Spot eats dog food, drinks from a bowl
2012-11-16 01:33:05 +0700: Spot is very hungry,  is very thirsty.
=end

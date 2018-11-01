require 'yaml'
require_relative './animal.rb'

class Zoo
  attr_accessor :animals
   
  def insert
    print "  Name of animal: "
    STDOUT.flush
    name = gets.strip
    
    print "  Type of food: "
    STDOUT.flush
    food = gets.strip
    
    print "  Water container: "
    STDOUT.flush
    container = gets.strip

    a = Animal.new(name,food,container)
    if (@animals.nil?)
      @animals = []
    end
    @animals.push a
  end
   
  def checkAll
    @animals.each{ |x|
      puts x.status
    }
    STDOUT.flush
  end

  def feedAll
    @animals.each{|x|
      if ! x.fed?
        x.feed
      end
    }
  end

  def waterAll
    @animals.each{|x|
      if ! x.watered?
        x.water
      end
    }
  end
    
  def listAll
    puts "List of animals:"
    @animals.each_index{|x|
      puts "  [#{x +1}] #{@animals[x]}"
    }
    STDOUT.flush
  end

  def select
    listAll
    print "Choose: "
    STDOUT.flush
    a = gets.strip.to_i
   
    puts "
  [C] - Check
  [F]  - Feed
  [W] - Water
  [R] - Remove
"
    STDOUT.flush
    command = gets.strip.upcase
      
    case command
      when 'C'
        puts @animals[a -1].status
        STDOUT.flush
      when 'F'
        @animals[a -1].feed
      when 'W'
        @animals[a -1].water
      when 'R'
        @animals.delete_at(a-1);
    end
  end
   
  def save
    File.open("zoo.yml","w") {|file|
        file.puts self.to_yaml
    }
    puts "Zoo archive updated"
    STDOUT.flush
  end
   
  def load(filename)
    puts "Zoo uploaded"
    YAML.load(File.open(filename))
  end
end

z = Zoo.new
puts "
======================
 Welcome to Zoo Admin
======================
"
STDOUT.flush 
filename = "zoo.yml"
if File.exists?(filename)
  z = z.load(filename)
end

begin
  if z.animals.nil? || z.animals.length < 1
    print "
Menu:
  [A] - Add an animal
  [Q] - Quit
"
  else 		
    print "
Menu:
  [A] - Add an animal
  [C] - Check on the animals
  [F] - Feed the animals
  [L] - List all animals
  [S] - Select an animal
  [W] - Water the animals
  [Q] - Quit
"
  end
  STDOUT.flush
	
  print "Choose one: "
  STDOUT.flush
  command = gets.strip.upcase

  puts
	STDOUT.flush	
  if z.animals.nil?
    if command == 'A'
      z.insert		
    end

  else 		
    case command
      when 'A'
        z.insert		
      when 'C'
        z.checkAll
      when 'F'
        z.feedAll
      when 'L'
        z.listAll
      when 'W'
        z.waterAll
      when 'S'
        z.select
    end
  end    
end while command != 'Q'
z.save

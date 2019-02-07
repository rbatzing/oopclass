class Game
	def initialize
		@target = rand(100).to_i
		@guess_count = 0
		@found = false
		puts "\nStarting a new game"
	end
	
	def another_game?
		print "Another Game [Y/N]?"
		STDOUT.flush
		return gets.chomp.upcase.eql?("Y")
	end
	
	def get_guess
		print "Your guess: [0-99]"
		STDOUT.flush
		@guess = gets.chomp.to_i
	end
	
	def check_guess
		@guess_count += 1
		if @guess < @target
			puts "#{@guess}: Too low"
		elsif @guess > @target
			puts "#{@guess}: Too high"
		elsif @guess == @target
			puts "#{@target}: found in #{@guess_count} guesses"
			if another_game?
				initialize
			else
				exit
			end
		end
	end
		
	def play
		until false
			get_guess
			check_guess
		end
	end
end

g = Game.new
g.play
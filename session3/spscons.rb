class ScissorsPaperStone
	CHOICES = [:Stone, :Paper, :Scissors]

	def initialize
		@tally = Hash.new(0)
		
	end
		  
	def compare(a,b)
		result = if a.eql?(b)
			:tied
		elsif a.eql?(CHOICES[0]) && b.eql?(CHOICES[2])
			:won
		elsif a.eql?(CHOICES[1]) && b.eql?(CHOICES[0])
			:won
		elsif a.eql?(CHOICES[2]) && b.eql?(CHOICES[1])
			:won
		else
			:lost
		end
		return result
	end
	
	def check(a,b)
		puts "You: %s Comp: %s." % [a.to_s,b.to_s]
		result = compare(a,b)
		@tally[result] += 1
		puts "You #{result.to_s}."
	end
	
	def to_s
		return "Score:  Win: %i  Lost: %i  Tied %i\n" % 
			[@tally[:won],@tally[:lost], @tally[:tied]] 
	end
	
	def getComputerChoice
		return CHOICES[rand(3)]
	end
	
	def getUserChoice
		choice  = -1
		until choice >= 0 && choice < 3 
			print "\nChoose one:\n[1] Scissors\n[2] Paper\n[3] Stone\n or [q]uit: "
      STDOUT.flush
			choice = gets.chomp.upcase
      if choice.eql?("Q")
        puts "Goodbye"
        exit
      end
      choice = choice.to_i - 1
		end
		return CHOICES[choice]
	end
	
	def play
		until false
			user = getUserChoice
			computer = getComputerChoice
			check(user,computer)
			puts self.to_s
		end
	end
end

g = ScissorsPaperStone.new
g.play
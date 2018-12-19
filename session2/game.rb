# game.rb - Game class for a Ruby Othello game
# (c)copyright 2019, Robert Batzinger, Payap University.
# All rights reserved.

# A class that manages the interface between the players, individual moves, and the data managed by the game board.
class Game

# The Othello game board as an array of cells
  attr_accessor :board
	
# The current player (either [B]lack or [W]hite)
	attr_accessor :turn

# A tally of the number of cells for each type of status 
	attr_accessor :count
  
	# Establishing a new game of Othello
  def initialize
    @board = GameBoard.new
    @turn = :W
    find_moves
    update_counts
  end
  
	# Display the game board with the status and score
  def to_s
    update_counts
    out = "\nTURN: #{@turn}, Possible moves: #{@count[:P]}"
    out += "  SCORE: Black: #{@count[:B]}, White: #{@count[:W]}\n"
    out += @board.to_s
    return out
  end
  
	# Switch to the next player
  def next_turn
    if @turn == :B
      @turn = :W
    else
      @turn = :B
    end
  end
  
	# Identify all possible moves for the current player
  def find_moves
    @board.clear
    64.times do |i|
      if @board[i].state.eql?(@turn)
        [-9,-8,-7,-1,1,7,8,9].each do |direction|
          @board.check_direction(i,direction)
        end
      end
    end    
  end
  
	# Update the tally of the status of the board
  def update_counts
    @count = Hash.new(0)
    64.times do |i|
      @count[@board[i].state] += 1
    end
  end
  
	# Choose one of the possible moves or quit
  def get_move
    @choice = 64
    until @choice >=0 && @choice < 64
      print "Your move or [q]uit:"
      STDOUT.flush
      selection = gets.chomp.downcase
      if selection.eql?("q")
        puts 
        final_score 
        exit
      end
      begin
        @choice = selection.to_i - 1    
        puts "#{@choice}  Position: #{@board[@choice].position} State: #{@board[@choice].state} " +
            "Direction: #{@board[@choice].direction}"
        STDOUT.flush
        raise if @board[@choice].state != :P
      rescue Exception
          puts "  *** Not a valid move. Try again"
          @choice = 64
      end
    end
    STDOUT.flush
    return @choice
  end

  # Register the captures resulting from the unit chosen  
  def update_board
      @board.mark_units!(@choice,@turn)
  end

	# Opening message
  def welcome
    puts <<EOM
WELCOME TO RUBY OTHELLO
#{COPYRIGHT}

EOM
  end

  # Display the outcome of the final move.  
  def final_score(msg="Game over: ")
    puts @board.to_s
    print msg
    if @count[:W] > @count[:B]
      puts "White wins    #{@count[:W]} to #{@count[:B]}"
    elsif @count[:B] > @count[:W]
      puts "Black wins  #{@count[:B]} to #{@count[:W]}"
    else
      puts "Tied game   #{@count[:B]} to #{@count[:W]}"
    end
  end

	# Manage a game of othello between 2 players taking turns
  def play_othello
    welcome
    loop do
      find_moves
      update_counts
      break if @count[:P] == 0
      puts to_s
      get_move
      update_board
      next_turn
    end
    final_score
  end  
end



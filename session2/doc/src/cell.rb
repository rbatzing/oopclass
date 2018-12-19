# cell.rb - Cell class
# (c)copyright 2019, Robert Batzinger, Payap University.
# All rights reserved.

# Class to define the behavior and attributes of each cell on an Othello game board
class Cell

  # ID Number of the cell
  attr_accessor :position
	
  # Current status of the cell: [:E]mpty, [:P]ossible move, [:B]lack, [:W]hite
	attr_accessor :state
	
  # Array of line directions representing sequences of opponent's cells that can be captured
	attr_accessor :direction
  
	# Establish a new cell in the gameboard with its label
  def initialize(position)
    @position = position
    reset
  end
  
	# Display the content of the cell
  def to_s
    if @state.eql?(:E)
      return " " * 4
    elsif @state.eql?(:P)
      return "[%2d]" % [@position]
    else
      return "  #{@state} "
    end
  end
  
	# Flip the ownership of a cell to the opposing player.
  def invert!
    if @state.eql?(:B)
      @state = :W
    elsif @state.eql?(:W)
      @state = :B
    end
  end
  
	# Returns a Boolean that indicates whether a cell is owned by the opponent of the owner of the base cell.
  def opposite?(unit)
    return ((@state == :B) && (unit.state == :W)) ||
      ((@state == :W) && (unit.state == :B))
  end
  
	# Marks a cell that could be possible move for the current player.
  def mark_possible(direction = 0)
    if (@state == :E) || (@state == :P)
      @state = :P
      @direction << direction
			
    end
  end

	# Switch a possible move back to an empty cell state.
  def clear
    if @state.eql?(:P)
      reset
    end
  end
  
  # Reset the cell back to the initial state and condition for starting a new game.
  def reset
    @state = :E
    @direction = Array.new
  end
end

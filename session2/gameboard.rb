# gameboard.rb - Game board class for a Ruby Othello game
# (c)copyright 2019, Robert Batzinger, Payap University.
# All rights reserved.

# A subclass of Arrays to collect all game cells into a single dimension array. Since Othello is played on a square board, row and column positions can be determined respectively by division or modulus by the width of the board.
class GameBoard < Array

  # Set up for a new game
  def initialize
    super
    65.times do |i|
      self << Cell.new(i + 1)
    end
    self[27].state = :B
    self[36].state = :B
    self[28].state = :W
    self[35].state = :W
  end

# Display the game board  
  def to_s
    out = "+" + (("-" * 6 ) + "+") * 8 + "\n"
    64.times do |i|
      if (i % 8) == 0
        out += "| "
      end
    
      out += self[i].to_s
    
      if ((i+1) % 8 ) == 0
        out += " |\n"
        out += "+" + (("-" * 6 ) + "+") * 8 + "\n"
      else
        out += " | "
      end
    end
    return out
  end
  
	# Clear the board for the next player
  def clear
    64.times do |i|
      self[i].clear
    end
  end
  
	# Check for areas that can be captured by the current player
  def check_direction(startcell,direction)

    # Check left and right margins
    if direction == -1 || direction == -9 || direction == 7
      return if startcell % 8 < 2 
    elsif direction == 1 || direction == 9 || direction == -7
      return if startcell % 8 > 5
    end
    
    # Check top and bottom margins
    if direction == -9 || direction == -8 || direction == -7
      return if startcell / 8 < 2 
    elsif direction == 7 || direction == 8 || direction == 9
      return if startcell / 8 > 5
    end
    
    k = startcell + direction
    return if !self[startcell].opposite?(self[k])

    case direction
    when -1 # W
      while k % 8 > 0 && self[startcell].opposite?(self[k])
        k += direction
      end

    when -9 # NW
      while k % 8 > 0 && k / 8 > 0  && self[startcell].opposite?(self[k])
        k += direction
      end
    when -8 # N
      while k / 8 > 0  && self[startcell].opposite?(self[k])
        k += direction
      end
    when -7 # NE
      while k % 8 < 7 && k / 8 > 0 && self[startcell].opposite?(self[k])
        k += direction
      end
    when 1 # E
      while k % 8 < 7 && self[startcell].opposite?(self[k])
        k += direction
      end
    when 9 # SE
      while k % 8 < 7 && k / 8 < 7 && self[startcell].opposite?(self[k])
        k += direction
      end
    when 8 # S
      while k / 8 < 7 && self[startcell].opposite?(self[k])
        k += direction
      end
    when 7 # SW
      while k % 8 > 0 && k / 8 < 7 && self[startcell].opposite?(self[k])
        k += direction
      end
    end      
    self[k].mark_possible(-direction)
  end  

	# Mark the cells that are captured by the current player
  def mark_units!(cell,player)
    self[cell].direction.each do |dir|
      pos = cell + dir
      until self[pos].state == player
        self[pos].invert!
        pos += dir
      end
    end
    self[cell].state = player
  end
end

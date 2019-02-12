class Cell
  attr_accessor :position, :state, :direction
  
  def initialize(position)
    @position = position
    @state = :E
	  reset
	end
  
  def to_s
		if @state.eql?(:E)
			return " " * 4
		elsif @state.eql?(:P)
			return "[%2d]" % [@position]
		else
			return "  #{@state} "
		end
  end
  
  def invert!
		if @state.eql?(:B)
			@state = :W
		elsif @state.eql?(:W)
			@state = :B
		end
  end
	
	def opposite?(unit)
	  return ((@state == :B) && (unit.state == :W)) ||
			((@state == :W) && (unit.state == :B))
	end
	
	def mark_possible(direction = 0)
	  if (@state == :E) || (@state == :P)
			@state = :P
			@direction << direction
		end
	end

	def clear
		if @state.eql?(:P)
			reset
		end
	end
	
	def reset
		@state = :E
		@direction = Array.new
	end		
end

class Game
  attr_accessor :board, :turn, :count
  
  def initialize(size)
    @board = Array.new
    @size = size
    @boardsize = size * size
    new_game
  end
  
  def new_game
		@boardsize.times do |i|
			@board << Cell.new(i + 1)
		end
    halfsize = @size / 2
		@board[halfsize * (@size + 1)].state = :B
    @board[halfsize * (@size + 1) - 1].state = :W
    @board[halfsize * (@size - 1)].state = :W
		@board[halfsize * (@size - 1) - 1].state = :B
		@turn = :W
  end
  
  def to_s
		out = "\nTURN: #{@turn}, Possible moves: #{@count[:P]}"
    out += "    SCORE: Black: #{@count[:B]}, White: #{@count[:W]}\n"
		out += "+" + (("-" * 6 ) + "+") * @size + "\n"
		@boardsize.times do |i|
			if col(i) == 0
				out += "| "
			end
	  
			out += @board[i].to_s
	  
			if col(i+1) == 0
				out += " |\n"
				out += "+" + (("-" * 6 ) + "+") * @size + "\n"
			else
				out += " | "
			end
		end
		return out
  end
	
	def next_turn
		if @turn == :B
			@turn = :W
		else
			@turn = :B
		end
	end
	
	def find_moves
	  @boardsize.times do |i|
			@board[i].clear
		end
		
		@boardsize.times do |i|
			if @board[i].state.eql?(@turn)
			  mark_move(i)
			end
		end		
	end
	
	def update_counts
		@count = Hash.new(0)
		@boardsize.times do |i|
			@count[@board[i].state] += 1
		end
	end
	
	def reverse_direction(d)
		return -d 
	end

  def mark_move(i)
    out = " #{i}:"
	  [-@size-1, -@size, -@size+1, -1,
        1, @size-1, @size, @size+1].each do |direction|
      
      k = i + direction
      map = k + direction

      # Abort if on the edge
      if k < @size   && direction < -1  # top
        next
      elsif k >= @boardsize - @size && direction > 1  # bottom
        next
      end

      if col(i) < 2 && direction % @size == @size -1 # left
        next
      elsif col(i) > @size - 3 && direction % @size == 1 # right
        next
      end

			k = i + direction
      
      if !@board[i].opposite?(@board[k])
        next;
      end
      
      nxt = k + direction
      cnt = 1
			while nxt > -1 && nxt < @boardsize && 
          (((direction % @size == @size -1) && (col(k) > 0) && (col(k) < @size - 1)) ||
           ((direction % @size == 1) && (col(k) > 0) && (col(k) < @size -1)) ||
           (direction % @size == 0)) &&  
           @board[i].opposite?(@board[k]) &&
          (@board[i].opposite?(@board[nxt]) || @board[nxt].state == :E || 
              @board[nxt].state == :P)
        k = nxt
        cnt += 1
				nxt += direction
			end
			if cnt > 0
				@board[k].mark_possible(reverse_direction(direction))
			end
      out += "#{direction},"
		end
    return out
	end
	
  def col(unit)
    return unit % @size
  end
 
  def get_black_move
    tmparry = Array.new
    @boardsize.times do |i|
			if @board[i].state.eql?(:P)
        tmparry << i
      end
    end
    @choice = tmparry[rand(tmparry.size)]
    return @choice
  end
      

 
	def get_move
		@choice = @boardsize
	  until @choice >=0 && @choice < @boardsize
		  print "Your move:"
			STDOUT.flush
			selection = gets.chomp.downcase
			exit if selection.eql?("q")
			@choice = selection.to_i - 1
   		puts "#{@choice} #{@board[@choice].inspect}"
			STDOUT.flush
      begin
        if @board[@choice].state != :P
          raise
        end
      rescue
        puts "  *** Not a valid move"
          @choice = @boardsize
      end
		end
		STDOUT.flush
		return @choice
	end
	
	def mark_units 
		@board[@choice].direction.each do |dir|
			pos = @choice + dir
			until @board[pos].state == @turn
			  @board[pos].invert!
				pos += dir
			end
		end
		@board[@choice].state = @turn
	end
  
  def play
    find_moves
    update_counts
    until @count[:P] == 0 do
      puts self.to_s
      get_move
      mark_units
      next_turn
      find_moves
      update_counts
      if @count[:P] != 0
        get_black_move
        mark_units
        next_turn
        find_moves
        update_counts
      end
    end
    puts self.to_s
  
    if @count[:B] > @count[:W]
      puts "BLACK wins!"
    elsif @count[:B] < @count[:W]
      puts "WHITE wins!"
    else
      puts "TIED game!"
    end
  end
  
  def autoplay
    find_moves
    update_counts
    until @count[:P] == 0 do
      puts self.to_s
      get_black_move
      mark_units
      next_turn
      find_moves
      update_counts
      if @count[:P] != 0
        get_black_move
        mark_units
        next_turn
        find_moves
        update_counts
      end
    end
    puts self.to_s
  
    if @count[:B] > @count[:W]
      puts "BLACK wins!"
      return :B
    elsif @count[:B] < @count[:W]
      puts "WHITE wins!"
      return :W
    else
      puts "TIED game!"
      return :T
    end
  end
end

class Othello
  def initialize
    @size = 0
    until @size > 3 && @size <=12
      puts "Size of board:"
      STDOUT.flush
      @size = gets.to_i
    end
    @g = Game.new(@size)
  end
  
  def play
    more = 'Y'
    while more.eql?("Y")
      @g = Game.new(@size)
      @g.play
      puts "Another Game?"
      STDOUT.flush
      more = gets.chomp.upcase
    end
  end
  
  def autoplay
    @tally = Hash.new(0)
    10000.times do
      @g = Game.new(@size)
      rtn = @g.autoplay
      @tally[rtn] += 1      
    end
    @tally.keys.sort.each do |k|
      puts "#{k} - #{@tally[k]}"
    end
  end
end

if __FILE__ == $0
  g = Othello.new
  g.autoplay
end
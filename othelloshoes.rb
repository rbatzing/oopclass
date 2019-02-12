class Cell
  attr_accessor :position, :state, :direction
  
  def initialize(position)
    @position = position
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

Shoes.app :width=>600, :height => 600 do
  COLORS = {:E => aquamarine, :P => gold,
      :B => midnightblue, :W => aliceblue}
  @buttons = Array.new
  @board = Array.new
  @tally = Hash.new(0)
  @turn = :B
  @size = 0    
  
  background teal
  stack do
    rect 40, 2, 520, 80,10, fill: aquamarine
    title "OTHELLO: Shoes version", size: 16,
      align: "center", weight: 1000  
    button "New Game", top: 35, left: 450 do
      @pComment.text = "State size"
      @size = 0
      until @size > 3 && @size < 11
        @size = ask("Othello Game Size (4-10)").to_i
      end
      @boardsize = @size * @size
      newgame
    end
    @pLabel = para "Current Player:", top: 30,
      left: 100
    @pTurn = para "WHITE", top: 30, left: 210,
      weight: 800
    @pScore = para "Score: WHITE: #{@tally[:W]}       BLACK: #{@tally[:B]}",
      top: 50, left: 100
    @pComment = para " ", top: 30, left: 280,
      stroke: darkred
    @bTurn =  rect 50, 30, 40, 40,20, fill: COLORS[:W]
  end
  
  def find_moves
    @pComment.text = "Finding moves"
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
    @pComment.text = "Update counts"
		@tally = Hash.new(0)
		@boardsize.times do |i|
			@tally[@board[i].state] += 1
		end
    @pScore.text =  "Score: WHITE: #{@tally[:W]}       BLACK: #{@tally[:B]}"
	end
	
	def reverse_direction(d)
		return -d 
	end
		
	def mark_move(i)
    @pComment.text = "Marking move"
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
		end
	end
	
  def col(unit)
    return unit % @size
  end
 	
	def mark_units(num)
    @pComment.text = "Marking choice"
		@board[num].direction.each do |dir|
			pos = num + dir
			until @board[pos].state == @turn
			  @board[pos].invert!
				pos += dir
			end
		end
		@board[num].state = @turn
	end

  def next_turn  
    if @turn.eql?(:W)
      @turn = :B
      @pTurn.text = "(BLACK)"
      @bTurn.fill = COLORS[:B]
    else
      @turn = :W
      @pTurn.text = "(WHITE)"
      @bTurn.fill = COLORS[:W]
    end
  end
  
  def update_board
    @boardsize.times do |i|
      @buttons[i].fill = COLORS[@board[i].state]
    end
  end
  
  def process(num)
    @pComment.text = "Selected: #{num}"
    if @board[num].state.eql?(:P)
      mark_units(num)
      next_turn
      find_moves
      update_counts
      update_board
      if @tally[:P] == 0
        if @tally[:B] > @tally[:W]
          @pComment.text = "Black wins."
        elsif @tally[:B] < @tally[:W]
          @pComment.text = "White wins."
        else
          @pComment.text = "Tied game."
        end
      end
    else
      @pComment.text = "Ignored, State: #{@board[num].state.to_s}"
    end
  end
  
  def newgame
    @buttons = Array.new
    @board = Array.new
    rect 1,95,600,600,fill: teal, stroke: teal
    
    @pComment.text = "New Game Setup"
    @size.times do |j|  
      @size.times do |i|
        num = j* @size + i
        @board[num] = Cell.new(num)
        stroke rgb(0, 2, 1)      
        @buttons[num] = rect 55 + i*50, 95+ j*50, 40, 40,20, fill: COLORS[:E]
        @buttons[num].click do
          @pComment.text = "Button clicked: #{num}"
          process(num)
        end
        para num.to_s, top: 100 + (j*50), left: 65 + (i* 50), align: "left"
      end
    end
    halfsize = @size / 2
    p1 = halfsize * (@size + 1)
    p2 = p1 - @size
    @board[p1].state = :B 
    @board[p1 - 1].state = :W
    @board[p2].state = :W
    @board[p2 - 1].state = :B
    next_turn
    find_moves
    update_board
    @pComment.text = "Choose a gold tile"
  end
end
require_relative "othello.rb"

class ShoesCell < Cell
  attr_accessor:button
  
  def initialize(position,button)
    @button = button
    super(position)
	end	
end

class Dummy
  
  def initialize(siz,screen,colors, pLabel, pTurn, pScore,
          pComment, bTurn)
          
    @size = siz
    @colors = colors
    @screen = screen
    
    @screen.debug(@screen.inspect)
    @pLabel = pLabel
    @pTurn = pTurn
    @pScore = pScore
    @pComment = pComment
    @bTurn = bTurn
    
    @board = Array.new
    @tally = Hash.new(0)
    @turn = :B
    @size = 0  
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
    @pComment.text = "Update counts"
    @tally = Hash.new(0)
    @boardsize.times do |i|
      @board[i].button.fill = COLORS[@board[i].state]
      @tally[@board[i].state] += 1
    end
    @pScore.text =  "Score: WHITE: #{@tally[:W]}       BLACK: #{@tally[:B]}"
  end
  
  def process(num)
    @pComment.text = "Selected: #{num}"
    if @board[num].state.eql?(:P)
      mark_units(num)
      next_turn
      find_moves
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
    @board = Array.new
    @screen.rect 1,95,600,600,fill: @colors[:bkgnd], 
        stroke: @colors[:bkgnd]
    
    @pComment.text = "New Game Setup"
    
    @size.times do |j|  
      @size.times do |i|
        num = j* @size + i
        @screen.debug(num)
        button = @screen.rect 55 + i*50, 95+ j*50, 40, 40,20, fill: @colors[:E], stroke: @colors[:B]
        button.click do
          @pComment.text = "Button clicked: #{num}"
          process(num)
        end
        @board[num] = ShoesCell.new(num,button)
        debug(@board[num])
        para num.to_s, top: 100 + (j*50), left: 65 + (i* 50), align: "left"
      end
    end
    halfsize = @size / 2
    p1 = halfsize * (@size + 1)
    p2 = p1 - @size
    
    debug(@board)
    @board[p1].state = :B 
    @board[p1 - 1].state = :W
    @board[p2].state = :W
    @board[p2 - 1].state = :B
    @turn = :B
    next_turn
    find_moves
    update_board
    @pComment.text = "Choose a gold tile"
  end
  
  def ender
  end
end

Shoes.app :width=>600, :height => 600, :margin => 5 do
  @COLORS = {:E => aquamarine, :P => gold,
:B => midnightblue, :W => aliceblue, :bkgnd => teal}  
  @size = 4
  @boardsize = 16
  
  background @COLORS[:bkgnd]

  def newgame
  end
  
  def show_boardsize
    return "Current board size: #{@size} x #{@size} (#{@boardsize}) "
  end

 
  @home = stack align: "center" do       
    stack top:100 do
      background @COLORS[:E]
      title "OTHELLO:\n Shoes version", size: 32,
        align: "center", weight: 1000, stroke: @COLORS[:B]
          
      para "(c) copyright 2019 by Dr Batzinger. All rights reserved)", align: "center"
      
      para "This version of Othello supports:",margin: 20, align: "left"

      para "- game boards ranging from 4x4 to 10x10.",margin_left: 40, align: "left"
      
      para "- two player game mode.",margin_left: 40, align: "left"

      button "Game setup" do 
        @home.hide
        @settings.show
      end
    end
  end
  
  @settings = stack do
    background @COLORS[:E]
    title "Game Settings", size: 32, fill: @COLORS[:E], stroke: @COLORS[:B],weight: 1000
  
    flow do
      @brdsize = para show_boardsize,margin: 20
      
      button "Change size" do 
        @size = 0
        until @size > 3 && @size < 11
          @size = ask("Othello Game Size (4-10)").to_i
        end
        @boardsize = @size * @size
        @brdsize.text = show_boardsize
      end
    end
    
    @mode = para "Play mode: 2-player", margin: 20
      
    flow do
      button "Home" do
        @home.show
        @settings.hide
      end
      
      button "Play Game" do
        @play.show
        newgame
        @settings.hide
      end
    end
  end
  @settings.hide
  
  @play = stack do 
      rect 40, 2, 520, 80,10, fill: @COLORS[:E]
      
      @pLabel = para "Current Player:", top: 10,
        left: 100
      @pTurn = para "WHITE", top: 20, left: 210,
        weight: 800
      @pScore = para "Score:",      top: 50, left: 100
      @pComment = para " ", top: 30, left: 280,
          stroke: darkred
      @bTurn =  rect 50, 30, 40, 40,20, fill: @COLORS[:W]    
      
      rect 1,1,600,600,fill: @COLORS[:bkgnd]
      
    flow do
      button "New Game" 
      button "Change Settings" do
        @play.hide
        @settings.show
      end

      button "Quit" do
        exit
      end

      button "Home" do
        @play.hide
        @home.show
      end
    end 
  end
  @play.hide

end

__END__

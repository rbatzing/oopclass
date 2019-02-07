Shoes.app :width => 320, :height => 100 do
  background gradient(rgb(255,99,71),rgb(255, 200, 120)) 
  @num = rand(100)
  @tries = 0
  stack :margin => 10 do
    flow :width => 300, :margin => 10 do
      @par = para "Guess a number: 0-99 "
      @el = edit_line :width => 40
    end
    @out = para "New Game"  
  end  
  @el.finish = proc {|slf|
    @tries += 1
    guess = slf.text.to_i
    if guess < @num
      @out.text = "#{slf.text}: Too small\n"
    elsif guess > @num
      @out.text = "#{slf.text}: Too large\n"
    else
      @out.text = "#{slf.text}: Found in #{@tries} tries"
      if confirm("Another game?")
        @out.text = "New Game\n"
        @num = rand(100)
        @tries = 0
      else
        exit
      end
    end
    slf.text = ""       
  }
end
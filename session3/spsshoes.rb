Shoes.app :width=>300, :height => 250 do
  background darkorange
  CHOICES = [:Paper, :Scissors, :Stone,]
  @tally = Hash.new(0) 
  
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
  
  def check(a)
    b = CHOICES[rand(3)]
    result = compare(a,b)
    @tally[result] += 1
    @p.text = "You: [%s]   Computer: [%s]." % [a.to_s,b.to_s]
    @p1.text = "You #{result.to_s}."
    @p2.text = "Score:  Win: [%i]  Lost: [%i]  Tied: [%i]" % 
        [@tally[:won],@tally[:lost], @tally[:tied]] 
  end
  
  stack margin: 10  do
    flow :align=>"center" do
      CHOICES.each do |c|
        button c.to_s do check(c); end
      end
    end
    @p = para "Challenge", align: "center"
    @p1 = para "Outcome", align: "center",weight: 700
    @p2 = para "Score:", align: "center"
  end
end

__END__
Earlier version of button defs:
      button "Scissors" do check(:Scissors); end
      button "Paper" do check(:Paper); end
      button "Stone" do check(:Stone); end

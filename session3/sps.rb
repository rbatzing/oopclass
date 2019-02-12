Shoes.app :width=>300, :height => 250 do
   background darkgreen
   stack do
     flow margin: 20 do
   button "Scissors"
   button "Paper"
   button "Stone"
     end
   para  "You: .... Computer: ....", align: "center"
   para  "You ....", align: "center"
   para  "Score:  Win: 000 Loose: 000  Tie: 000", align: "center"
   end
end
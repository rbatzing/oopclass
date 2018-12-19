# othello.rb - A Ruby Othello game application
# (c)copyright 2019, Robert Batzinger, Payap University.
# All rights reserved.

require_relative "game.rb"
require_relative "gameboard.rb"
require_relative "cell.rb"

g = Game.new
g.play_othello

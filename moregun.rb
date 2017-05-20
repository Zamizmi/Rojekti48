#!/usr/bin/env ruby

require './lib/gameWindow'

window = GameWindow.new(WIDTH, HEIGHT)
window.show if __FILE__ == $0
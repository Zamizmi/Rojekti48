#!/usr/bin/env ruby

require './lib/gameWindow'
require './lib/menu'

window = Menu.new
window.show if __FILE__ == $0

require 'rubygems'
require 'gosu'

WIDTH, HEIGHT = 1075, 500


class Menu < Gosu::Window
  def initialize(width=WIDTH, height=HEIGHT)

    super width, height

    @font_size = 20
    @font = Gosu::Font.new(20)
    @text =
      "<b>Welcome to the Gosu Example Box!</b>

      This little tool lets you launch any of Gosu’s example games from the list on the right hand side of the screen.

      Every example can be run both from this tool <i>and</i> from the terminal/command line as a stand-alone Ruby script.

      Keyboard shortcuts:

      • Choose map by pressing appropriate numbers, 1-4
      • To open the ‘examples’ folder, press <b>O</b>.
      • To quit this tool, press <b>Esc</b>.
      <p> asd</p>

      Why not take a look at the code for this example right now? Simply press <b>S</b>."
  end

end

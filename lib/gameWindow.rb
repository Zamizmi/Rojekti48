require 'rubygems'
require 'gosu'

require './lib/levels/level'
require './lib/player/player'


WIDTH, HEIGHT = 1075, 500

class GameWindow < Gosu::Window
  def initialize(width=WIDTH, height=HEIGHT)

    super width, height

    self.caption = "MoreGun"

    @background = Gosu::Image.new('assets/space.png', :tileable => true)
    @level = Level.new('assets/example_map.txt')
    @character = Player.new(@level, 200, 50)
    @level.addBox(250, 300)
    # The scrolling position is stored as top left corner of the screen.
    @camera_x = @camera_y = 0
  end

  def update
    move_x = 0
    move_x -= 5 if Gosu.button_down? Gosu::KB_LEFT
    move_x += 5 if Gosu.button_down? Gosu::KB_RIGHT
    @character.update(move_x)
    #@character.collect_gems(@level.gems)
    # Scrolling follows player
    #@camera_x = [[@character.x - WIDTH / 2, 0].max, @level.width * 50 - WIDTH].min
    #@camera_y = [[@character.y - HEIGHT / 2, 0].max, @level.height * 50 - HEIGHT].min
  end

  def draw
    @background.draw 0, 0, 0
    Gosu.translate(-@camera_x, -@camera_y) do
      @level.draw
      @character.draw
    end
  end

  def button_down(id)
    case id
      when Gosu::KB_UP
        @character.try_to_jump
      when Gosu::KB_ESCAPE
        close
      else
        super
    end
  end
end


window = GameWindow.new(WIDTH, HEIGHT)
window.show if __FILE__ == $0

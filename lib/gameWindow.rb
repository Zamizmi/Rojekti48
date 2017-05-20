require 'rubygems'
require 'gosu'

require './lib/levels/level'
require './lib/player/player'


WIDTH, HEIGHT = 1366, 768

class GameWindow < Gosu::Window
  def initialize(width=WIDTH, height=HEIGHT)

    super WIDTH, HEIGHT, fullscreen = true

    self.caption = "MoreGun"

    @background = Gosu::Image.new('./assets/space.png', :tileable => true)
    @level = Level.new('./assets/map2.txt', WIDTH)
    @character = Player.new(@level, 200, 50, 1)
    @character2 = Player.new(@level, 400, 50, 2)
    @level.addBox(250, 300)
  end

  def update
    move_x = 0
    move_x -= 5 if Gosu.button_down? Gosu::KB_LEFT
    move_x += 5 if Gosu.button_down? Gosu::KB_RIGHT
    move_x2 = 0
    move_x2 -= 5 if Gosu.button_down? Gosu::KbA
    move_x2 += 5 if Gosu.button_down? Gosu::KbD
    @character.update(move_x)
    @character.collect_boxes(@level.boxes)
    @character.shoot if Gosu.button_down? Gosu::KbL
    @character2.update(move_x2)
    @character2.collect_boxes(@level.boxes)
    @character2.shoot if Gosu.button_down? Gosu::KbR

    @level.updateBullets
  end

  def draw
    @background.draw 0, 0, 0
    @level.draw
    @character.draw
    @character2.draw
  end

  def button_down(id)
    case id
      when Gosu::KB_UP
        @character.try_to_jump
      when Gosu::KbW
        @character2.try_to_jump
      when Gosu::KB_ESCAPE
        close
      else
        super
    end
  end
end

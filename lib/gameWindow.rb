require 'rubygems'
require 'gosu'

require './lib/levels/level'
require './lib/player/player'
require './lib/robot/robot'
require './lib/explosion/explosion'


WIDTH, HEIGHT = 1366, 768

module ZOrder
  BACKGROUND, STARS, PLAYER, UI = *0..3
end

class GameWindow < Gosu::Window
  def initialize(width=WIDTH, height=HEIGHT)

    super WIDTH, HEIGHT, fullscreen = true

    self.caption = "MoreGun"

    @background = Gosu::Image.new('./assets/spookyWoods.png', :tileable => true)
    @level = Level.new('./assets/example_map3.txt', WIDTH)
    @character = Player.new(@level, 200, 50, 1)
    @character2 = Player.new(@level, 400, 50, 2)

    @level.addPlayer(@character)
    @level.addPlayer(@character2)
    @level.addRobot(260, 300)
    @level.addExplosion(300,300)
    @font = Gosu::Font.new(20)
		self.play_music('./assets/audio/battleMusic.mp3')

  end

  def update
    move_x = 0
    move_x -= 4 if Gosu.button_down? Gosu::KB_LEFT
    move_x += 4 if Gosu.button_down? Gosu::KB_RIGHT
    move_x2 = 0
    move_x2 -= 4 if Gosu.button_down? Gosu::KbA
    move_x2 += 4 if Gosu.button_down? Gosu::KbD
    @character.update(move_x)
    @character.collect_boxes(@level.boxes)
    @character.shoot if Gosu.button_down? Gosu::KbL
    @character2.update(move_x2)
    @character2.collect_boxes(@level.boxes)
    @character2.shoot if Gosu.button_down? Gosu::KbR
    @level.robots.each { |r| r.update  }
    @level.boxes.each { |b| b.update }
    @level.explosions.each { |e| e.update}
    @level.randomBot
    @level.updateBullets
  end

  def draw
    @background.draw 0, 0, 0
    @level.draw
    @character.draw
    @character2.draw
    @font.draw("Health: #{@character2.health} Boxes: #{@character2.boxes_collected}", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLUE)
    @font.draw("Health: #{@character.health} Boxes: #{@character.boxes_collected}", 1180, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::RED)
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

  def play_music(filepath)
    @music = Gosu::Song.new(filepath)
    @music.volume = 0.4
    @music.play(looping = true)
  end
end

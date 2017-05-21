require 'gosu'
require 'rubygems'
require './lib/gameWindow'


class Menu < Gosu::Window

  module ZOrder
    BACKGROUND, STARS, PLAYER, UI = *0..3
  end

  def initialize
    super WIDTH, HEIGHT, fullscreen = true
    self.caption = "MoreGun Menu"
    @background = Gosu::Image.new('./assets/spookyWoods.png', :tileable => true)
    @map_path = ""

    @font = Gosu::Font.new(30)
    @text = "Welcome to MoreGun game! Choose map by pressing 'Q' 'W 'E or 'R'."
    @menu = self
    @pics = Array.new
  end

  def add_item (image, x, y, z, callback, hover_image = nil)
    item = MenuItem.new(@play, image, x, y, z, callback, hover_image)
    @pics << item
    self
  end

  def draw
    @background.draw 0, 0, 0
    @font.draw(@text,300, 400, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
    @pics.each do |i|
      i.draw
    end
  end

  def update
      @pics.each do |i|
        i.update
      end
  end

  def update_path(new_path)
    @map_path = new_path
  end

  def start
    window = GameWindow.new(@map_path)
    window.show# if __FILE__ == $0
  end

  def button_down(id)
    case id
    when Gosu::KbQ
        @map_path = './assets/example_map1.txt'
        #close
        start
      when Gosu::KbW
        @map_path = './assets/example_map2.txt'
        #close
        start
      when Gosu::KbE
        @map_path = './assets/example_map3.txt'
        #close
        start
      when Gosu::KbR
        @map_path = './assets/example_map4.txt'
        #close
        start
      when Gosu::KB_ESCAPE
        close
      else
        super
    end
  end

end

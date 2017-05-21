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
    @text = "Welcome to MoreGun game! Choose map by pressing 'Q' 'W' 'E' 'R' or 'T'."
    @menu = self
    @pics = Array.new
    @pic1 = Gosu::Image.new('./assets/level_images/example_map-Hole.png', :tileable => true).subimage(50,50,200,200)
    @pics << @pic1
    @pic2 = Gosu::Image.new('./assets/level_images/example_map-Hole.png', :tileable => true).subimage(50,50,200,200)
    #@pics << @pic2
    @pic3 = Gosu::Image.new('./assets/level_images/example_map-Hole.png', :tileable => true).subimage(50,50,200,200)
    #@pics << @pic3
    @pic4 = Gosu::Image.new('./assets/level_images/example_map-Hole.png', :tileable => true).subimage(50,50,200,200)
    #@pics << @pic4
    #add_item((Gosu::Image.new('./assets/level_images/dropMap-Drop_Zone.png', :tileable => true)), 200, 300, close, nil)
    #add_item(Gosu::Image.new('./assets/level_images/example_map-Hole.png', :tileable => true))
    #add_item(Gosu::Image.new('./assets/level_images/example_map2-FInal_Destination.png', :tileable => true))
    #add_item(Gosu::Image.new('./assets/level_images/example_map3-X_crossing.png', :tileable => true))
    #add_item(Gosu::Image.new('./assets/level_images/example_map4-Barren_area.png', :tileable => true))
  end

  def draw
    @background.draw 0, 0, 0
    @font.draw(@text,300, 400, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
    @pics.each do |i|
      i.draw 200, 400, 0
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
        @map_path = './assets/example_map.txt'
        start
      when Gosu::KbW
        @map_path = './assets/example_map1.txt'
        #close
        start
      when Gosu::KbE
        @map_path = './assets/example_map2.txt'
        #close
        start
      when Gosu::KbR
        @map_path = './assets/example_map3.txt'
        #close
        start
      when Gosu::KbT
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

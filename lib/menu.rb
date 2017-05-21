require 'gosu'
require 'rubygems'
require './lib/gameWindow'


class Menu < Gosu::Window

  module ZOrder
    BACKGROUND, STARS, PLAYER, UI = *0..3
  end

attr_accessor :winner

  def initialize
    super WIDTH, HEIGHT, fullscreen = true
    self.caption = "MoreGun Menu"
    @background = Gosu::Image.new('./assets/spookyWoods.png', :tileable => true)
    @map_path = ""
    @self = self
    @text =""
    @font = Gosu::Font.new(30)
    @text = "Welcome to MoreGun game! Choose map by pressing 'Z' 'X' 'C' 'V' or 'B'."
    @menu = self
    @background_music = Gosu::Song.new('./assets/audio/menuTheme.mp3')
    @pics = Array.new
    @pic1 = Gosu::Image.new('./assets/level_images/dropMap-Drop_Zone.png', :tileable => true)
    @pics << @pic1
    @pic2 = Gosu::Image.new('./assets/level_images/example_map-Hole.png', :tileable => true)
    @pics << @pic2
    @pic3 = Gosu::Image.new('./assets/level_images/example_map2-Final_Destination.png', :tileable => true)
    @pics << @pic3
    @pic4 = Gosu::Image.new('./assets/level_images/example_map3-X_crossing.png', :tileable => true)
    @pics << @pic4
    @pic5 = Gosu::Image.new('./assets/level_images/example_map4-Barren_area.png', :tileable => true)
    @pics << @pic5
    @background_music.play(looping = true)
    @window = ""
    #@winner = ""
  end

  def draw
    @x = 200
    @y = 450
    @i =1
    @background.draw 0, 0, 0
    @font.draw(@text,300, 400, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
    @pics.each do |i|
      i.draw @x*@i, @y, 0
      @i+=1
    end
  end

  def update_path(new_path)
    @map_path = new_path
  end

  def start
    @background_music.stop
    @window = GameWindow.new(@map_path, @self)
    @window.show
  end

  def end_game
    @window = Menu.new
    close
    @window.show
  end

  def button_down(id)
    case id

    when Gosu::KbZ
        @map_path = './assets/dropMap.txt'
        start
      when Gosu::KbX
        @map_path = './assets/example_map1.txt'
        #close
        start
      when Gosu::KbC
        @map_path = './assets/example_map2.txt'
        #close
        start
      when Gosu::KbV
        @map_path = './assets/example_map3.txt'
        #close
        start
      when Gosu::KbB
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

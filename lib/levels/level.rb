require 'rubygems'
require 'gosu'
require './lib/item/box'
require './lib/bullet/bullet'

module Tiles
  Grass = 0
  Earth = 1
end

# Map class holds and draws tiles and gems.
class Level
  attr_reader :width, :height, :boxes

  def initialize(filename, window_width)
    # Load 60x60 tiles, 5px overlap in all four directions.
    @tileset = Gosu::Image.load_tiles('./assets/platform.png', 23, 23, :tileable => true)

    box_img = Gosu::Image.new('./assets/box.png')


    @window_width = window_width
    @bullets = []
    @boxes = []
    lines = File.readlines(filename).map { |line| line.chomp }
    @height = lines.size
    @width = lines[0].size
    @tiles = Array.new(@width) do |x|
      Array.new(@height) do |y|
        case lines[y][x, 1]
          when '"'
            Tiles::Grass
          when '#'
            Tiles::Earth
          when 'x'
            nil
          else
            nil
        end
      end
    end
  end

  def addBox(x, y)
    @box = Box.new(x, y)
    @boxes.push(@box)
  end

  def addBullet(x, y, dir)
    bullet = Bullet.new(x, y, dir, self)
    @bullets.push(bullet)
  end

  def updateBullets
    @bullets.each {|b| b.update}
  end

  def draw
    # Very primitive drawing function:
    # Draws all the tiles, some off-screen, some on-screen.
    @height.times do |y|
      @width.times do |x|
        tile = @tiles[x][y]
        if tile
          # Draw the tile with an offset (tile images have some overlap)
          # Scrolling is implemented here just as in the game objects.
          @tileset[tile].draw(x * 20 - 5, y * 20 - 5, 0)
        end
      end
    end
    @bullets.each { |b| b.draw }
    @boxes.each { |b| b.draw }
  end

  # Solid at a given pixel position?
  def solid?(x, y)
    y < 0 || x < 0 || x > @window_width || @tiles[x / 20][y / 20]
  end

  def getRandomStart()
    #TODO
  end
end

require 'rubygems'
require 'gosu'
require './lib/item/box'
require './lib/bullet/bullet'
require './lib/robot/robot'
require './lib/explosion/explosion'

LEVEL_SCALE = 0.75
TILE_SIZE = 0.75
BOT_DELAY = 800

module Tiles
  Grass = 0
  Earth = 1
end

# Map class holds and draws tiles and gems.
class Level
  attr_reader :width, :height, :boxes, :robots, :explosions

  def initialize(filename, window_width)
    # Load 60x60 tiles, 5px overlap in all four directions.
    @tileset = Gosu::Image.load_tiles('./assets/platform.png', 60, 60, :tileable => true)

    box_img = Gosu::Image.new('./assets/box.png')

    @explosion_sample = Gosu::Sample.new('./assets/audio/explosion.wav')
    @window_width = window_width
    @bullets = []
    @boxes = []
    @players =[]
    @robots = []
    @explosions = []
    @last_bot = 0
    lines = File.readlines(filename).map {|line| line.chomp}
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

  def addPlayer(player)
    @players.push(player)
  end

  def addBox(x, y)
    @box = Box.new(self, x, y)
    @boxes.push(@box)
  end

  def addRobot(x, y)
    @robot = Robot.new(self, x, y)
    @robots.push(@robot)
  end

  def addExplosion(x,y)
    @explosion = Explosion.new(self,x,y)
    @explosions.push(@explosion)
  end

  def addBullet(x, y, dir, spread=0)
    bullet = Bullet.new(x, y, dir, self, spread)
    @bullets.push(bullet)
  end

  def updateBullets
    would_hit
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
          @tileset[tile].draw(x * 60*LEVEL_SCALE - 5, y * 60*LEVEL_SCALE - 5, 0, LEVEL_SCALE+0.1, LEVEL_SCALE+0.1)
        end
      end
    end
    @bullets.each {|bullet| bullet.draw}
    @boxes.each {|box| box.draw}
    killer
    @robots.each {|r| r.draw}
    explosionKiller
    @explosions.each { |e| e.draw}
  end

  def would_hit
    @bullets.each do |b|
      @players.each do |p|
        if p.is_inside?(b.instance_variable_get(:@x), b.instance_variable_get(:@y))
          p.take_damage(2)
          @bullets.delete(b)
        end
      end
      @robots.each do |r|
        if r.is_inside?(b.instance_variable_get(:@x), b.instance_variable_get(:@y))
          r.take_damage(2)
          @bullets.delete(b)
        end
      end
      if solid?(b.instance_variable_get(:@x), b.instance_variable_get(:@y))
        @bullets.delete(b)
      end
    end
  end

  def explosionKiller
      @explosions.reject! do |e|
        if Gosu.milliseconds - e.birth>299
          true
        else
          false
      end
    end
  end

  def killer
      @robots.reject! do |robot|
        if robot.hp<1
          addBox(robot.x, robot.y)
          addExplosion(robot.x, robot.y)
          @explosion_sample.play(volume = 0.5)
          true
        else
          false
      end
    end
  end

  def randomBot

    if Gosu.milliseconds - @last_bot < BOT_DELAY
      return
    end
    if robots.size>14
    return
    end
    x=rand(30...1300)
    y=rand(30...700)
    unless solid?(x,y) || solid?(x+16,y) || solid?(x-16,y) || solid?(x,y-16) || solid?(x,y+16) || solid?(x,y-30)
      addRobot(x, y)
      @last_bot = Gosu.milliseconds
    end

  end

  # Solid at a given pixel position?
  def solid?(x, y)
    if @tiles.length <= x / (60*LEVEL_SCALE) or @tiles[0].length <= y / (60*LEVEL_SCALE)
      return true
    end
    y < 0 || x < 0 || x > @window_width || @tiles[x / (60*LEVEL_SCALE)][y / (60*LEVEL_SCALE)]
  end

  def getRandomStart()
    #TODO
  end
end

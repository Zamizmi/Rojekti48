require 'rubygems'
require 'gosu'
require './lib/item/box'
require './lib/bullet/bullet'
require './lib/robot/robot'
require './lib/item/balloon'
require './lib/explosion/explosion'
require './lib/player/player'

LEVEL_SCALE = 0.75
TILE_SIZE = 0.75
BOT_DELAY = 6000

module Tiles
  Grass = 0
  Grass2 = 1
  Earth = 2
  Earth2 = 3
end

# Map class holds and draws tiles and gems.
class Level

  attr_reader :width, :height, :items, :robots, :start_points, :explosions

  def initialize(filename, window_width)
    # Load 60x60 tiles, 5px overlap in all four directions.
    @tileset = Gosu::Image.load_tiles('./assets/tileset.png', 60, 60, :tileable => true)

    @pop_sample = Gosu::Sample.new('./assets/audio/balloonPop.wav')
    @explosion_sample = Gosu::Sample.new('./assets/audio/explosion.wav')
    @window_width = window_width
    @bullets = []
    @items = []
    @players =[]
    @robots = []
    @flying = 0
    @explosions = []
    @last_bot = 0
    @start_points = []
    lines = File.readlines(filename).map {|line| line.chomp}
    @height = lines.size
    @width = lines[0].size
    @tiles = Array.new(@width) do |x|
      Array.new(@height) do |y|
        case lines[y][x, 1]
          when '"'
            if Random.rand() > 0.5
              Tiles::Grass2
            else
              Tiles::Grass
            end
          when '#'
            if Random.rand() > 0.5
              Tiles::Earth2
            else
              Tiles::Earth
            end
          when 'x'
            @start_points.push([x*(LEVEL_SCALE*60)+LEVEL_SCALE*60*0.5, y*(LEVEL_SCALE*60)+LEVEL_SCALE*60*0.5])
            nil
          else
            nil
        end
      end
    end
    raise "Map needs atleast 2 spawn locations marked with \"x\"!" if @start_points.length <2
    @start_points.shuffle!
  end

  def addPlayer(player)
    @players.push(player)
  end

  def addBox(x, y)
    @box = Box.new(self, x, y)
    @items.push(@box)
  end

  def addBalloon(x, y)
    @balloon = Balloon.new(self, x, y)
    @items.push(@balloon)
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
    @robots.each {|robot| robot.draw}
    killer
    @items.each{|i| i.draw}
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
      @items.each do |i|
        if i.is_inside?(b.instance_variable_get(:@x), b.instance_variable_get(:@y))
          @items.delete(i)
          @pop_sample.play(volume = 2)
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
          if @flying == 1
            addBalloon(robot.x, robot.y)
            @flying = 0
          else
            addBox(robot.x, robot.y)
            @flying = 1
          end
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
    if robots.size>8
    return
    end
    x=rand(30...1300)
    y=rand(30...700)
    @players.each do |p|
      if Gosu.distance(x,y,p.x,p.y) <45
        return
      end
    end
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
    @start_points.pop
  end
end

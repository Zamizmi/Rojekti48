require 'rubygems'
require 'gosu'

require './lib/levels/level'
class Robot
  attr_reader :x, :y, :hp, :damage

  def initialize(level, x, y)
    @hp = 14
    @x, @y = x, y
    @image = Gosu::Image.new("assets/robot.png")
    @vy = 0 # Vertical velocity
    @level = level
    @dir = :left
    @cur_image = @image
    @damage = 5
  end

  def take_damage (amount)
    @hp -= amount
  end

  def draw
    # Flip vertically when facing to the right.
    if @dir == :left
      offs_x = -16
      factor = 1.0
    else
      offs_x = 16
      factor = -1.0
    end
    @cur_image.draw(@x + offs_x, @y - 31, 0, factor, 1.0)
  end

# Could the object be placed at x + offs_x/y + offs_y without being stuck?
  def would_fit(offs_x, offs_y)
    # Check at the center/top and center/bottom for map collisions
    not @level.solid?(@x + offs_x, @y + offs_y) and
        not @level.solid?(@x + offs_x, @y + offs_y - 25)
  end

  def is_inside?(x, y)
    x < (@x + OFFS_X * SCALE * 0.5) and x > (@x - OFFS_X * SCALE * 0.5) and y < (@y + OFFS_Y * SCALE) and y > (@y - OFFS_Y * SCALE)
  end

  def is_close_enough?(x, y)
    Gosu.distance(@x, @y, x, y) < 10
  end

  def update

      move_x = 2
    # Directional automated walking, horizontal movement
    if @dir == :right

      move_x.times {
        if would_fit(13, 0)
        then
          @x += 1
        else
          if @x+30 > WIDTH && would_fit(-1*WIDTH + 30, 0)
            @x = 10
          else
            @dir = :left
          end
        end }
    end

    if @dir == :left
      (move_x).times {
        if would_fit(-10, 0)
        then
          @x -= 1
        else
          if @x-10 < 0 && would_fit(WIDTH - 30, 0)
            @x = WIDTH-10
          else
            @dir = :right
          end
        end }
    end

    # Acceleration/gravity
    # By adding 1 each frame, and (ideally) adding vy to y, the player's
    # jumping curve will be the parabole we want it to be.
    @vy += 1 if @vy < 20
    # Vertical movement
    if @vy > 0
      @vy.times {
        if would_fit(0, 1)
        then
          @y += 1
        else
          if @y+20 > HEIGHT && would_fit(0, -1*HEIGHT + 30)
            @y = 30
          else
            @vy = 0
          end
        end }
    end
    if @vy < 0
      (-@vy).times { if would_fit(0, -1) then @y -= 1 else @vy = 0 end }
    end
  end
end

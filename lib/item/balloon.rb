require 'rubygems'
require './lib/levels/level'

class Balloon
  attr_reader :x, :y, :firespeed_increase

  def initialize(level, x, y)
    @image = Gosu::Image.new('./assets/balloon.png')
    @x, @y = x, y
    @firespeed_increase = 20
    @vy = 1
    @level = level
  end

  def draw
    off_y = 10
    # Draw, slowly rotating
    @image.draw_rot(@x, @y + off_y, 0, 5 * Math.sin(Gosu.milliseconds / 133.7))
  end

  def would_fit(offs_x, offs_y)
    # Check at the center/top and center/bottom for map collisions
    not @level.solid?(@x + offs_x, @y + offs_y)
  end

  def is_close_enough?(x, y)
    Gosu.distance(@x, @y + 20, x, y) < 20
  end

  def is_inside?(x, y)
    x < (@x + 20) and x > (@x) and y < (@y + 10) and y > (@y - 10)
  end

  def update
    # Vertical movement
    @level.items.delete(self) if @y<5

    if @vy > 0
      @vy.times { if would_fit(0, -1) then @y -= 1 else @vy = 0 end }
    end
  end

end
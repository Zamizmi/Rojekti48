require 'rubygems'
require './lib/levels/level'

class Box
  attr_reader :x, :y, :firespeed_increase

  def initialize(level, x, y)
    @image = Gosu::Image.new('./assets/box.png')
    @x, @y = x, y
    @firespeed_increase = 20
    @vy = 0
    @level = level
  end

  def draw
    offs_y = 10
    # Draw, slowly rotating
    @image.draw_rot(@x, @y - offs_y, 0, 5 * Math.sin(Gosu.milliseconds / 133.7))
  end

  def is_close_enough?(x, y)
    Gosu.distance(@x, @y, x, y) < 20
  end


  def is_inside?(x, y)
    false
  end

  def would_fit(offs_x, offs_y)
    # Check at the center/top and center/bottom for map collisions
    not @level.solid?(@x + offs_x, @y + offs_y)
  end

  def update
    @vy += 1
    # Vertical movement
    if @vy > 0
      @vy.times { if would_fit(0, 1) then @y += 1 else @vy = 0 end }
    end
  end

end

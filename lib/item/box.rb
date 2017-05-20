require 'rubygems'

class Box
  attr_reader :x, :y, :firespeed_increase

  def initialize(x, y)
    @image = Gosu::Image.new('./assets/box.png')
    @x, @y = x, y
    @firespeed_increase = 1
  end

  def draw
    # Draw, slowly rotating
    @image.draw_rot(@x, @y, 0, 5 * Math.sin(Gosu.milliseconds / 133.7))
  end
end

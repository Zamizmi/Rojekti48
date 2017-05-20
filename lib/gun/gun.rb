require 'rubygems'
require 'gosu'

require './lib/bullet/bullet'

class Gun
  def initialize(x, y)
    @x = x, @y = y
    #@bullet = Bullet.new
  end

  def shoot
    @bullet = Bullet.new
  end
end

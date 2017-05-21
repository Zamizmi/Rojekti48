require 'rubygems'
require 'gosu'
require './lib/levels/level'



class Explosion
  attr_reader :x, :y, :birth

  def initialize(level, x, y)
    @x, @y = x, y
    # Load all animation frames
    @state1, @state2, @state3, @state4, @state5, @state6, @state7 = *Gosu::Image.load_tiles('./assets/explosion.png', 34 , 30)
    @cur_image= @state1
    # Set the delay between animation frames
    @state_delay = 250
    @birth = Gosu.milliseconds
  end

  def draw

    # Draw, slowly rotating
    @cur_image.draw(@x- 16, @y - 31, 0 , 1 , 1)
  end

  def update
    case Gosu.milliseconds-@birth
    when 0..60 then @cur_image = @state1
    when 61..90 then @cur_image = @state2
    when 91..140 then @cur_image = @state3
    when 141..170 then @cur_image = @state4
    when 171..199 then @cur_image = @state5
    when 200..259 then @cur_image = @state6
    when 260..299 then @cur_image = @state7
    end
  end
end

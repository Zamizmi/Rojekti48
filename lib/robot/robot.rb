require 'rubygems'
require 'gosu'

class Robot
  attr_reader :x, :y

  def initialize(level, x, y)
    @hp = 20
    @x, @y = x, y
    @image = Gosu::Image.new("assets/robot.png")
    @vy = 0 # Vertical velocity
    @level = level
    @dir = :left
    @die = false
    @cur_image = @image
  end

  def take_damage (amount)
    @hp - amount
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

    def update
      move_x = 2
    # Directional automated walking, horizontal movement
    if @dir == :right

      move_x.times { if would_fit(1, 0) then @x += 1 else @dir = :left end }
    end

    if @dir == :left
      (move_x).times { if would_fit(-1, 0) then @x -= 1 else @dir = :right end }
    end

    # Acceleration/gravity
    # By adding 1 each frame, and (ideally) adding vy to y, the player's
    # jumping curve will be the parabole we want it to be.
    @vy += 1
    # Vertical movement
    if @vy > 0
      @vy.times { if would_fit(0, 1) then @y += 1 else @vy = 0 end }
    end
    if @vy < 0
      (-@vy).times { if would_fit(0, -1) then @y -= 1 else @vy = 0 end }
    end
  end

  #Sets death status to true
  def kill
    @die=true
  end

  #Checks remaining hp
  def checkHp
    if @hp < 1
      kill
    end
  end

  #Checks death status
  def kill?
    @die
  end





end

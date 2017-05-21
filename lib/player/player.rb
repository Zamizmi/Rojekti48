require 'rubygems'
require 'gosu'

require './lib/gun/gun'

SCALE = 0.5
OFFS_X = 35
OFFS_Y = 55
SHOOT_DELAY = 500

class Player
  attr_reader :x, :y, :health, :boxes_collected
  attr_accessor :state
  def initialize(level, x, y, race)
    @jump_slowness = 0
    @last_shot = 0
    @health = 100
    @gun = Gun.new(x,y)
    @firespeed = 10
    @x, @y = x, y
    @dir = :left
    @vy = 0 # Vertical velocity
    @level = level
    @race = race
    @boxes_collected = 0
    @dead = false
    @jump_sample = Gosu::Sample.new('./assets/audio/jump.wav')
    @upgrade_sample = Gosu::Sample.new('./assets/audio/upgrade.wav')

    @shot_sample = Gosu::Sample.new('./assets/audio/shot.wav')

    if(race == 1)
      char_file = './assets/player1.png'
    else
      char_file = './assets/player2.png'
    end
    # Load all animation frames
    @standing, @walk1, @walk2, @jump, @shoot, @die = *Gosu::Image.load_tiles(char_file, 70, 56)
    # This always points to the frame that is currently drawn.
    # This is set in update, and used in draw.
    @cur_image = @standing
  end

  def is_inside?(x, y)
    x < (@x + OFFS_X * SCALE * 0.5) and x > (@x - OFFS_X * SCALE * 0.5) and y < (@y + OFFS_Y * SCALE) and y > (@y - OFFS_Y * SCALE)
  end

  def collect_boxes(boxes)
      boxes.reject! do |box|
        if Gosu.distance(@x, @y, box.x, box.y) < 20
          @firespeed += box.firespeed_increase
          @boxes_collected +=1
          @upgrade_sample.play
          true
        else
          false
      end
    end
  end

  def take_damage (amount)
    @health -= amount if @health > 0
    if @health < 1
      @dead = true
      @cur_image = @die
    end
  end

  def is_dead?
    @dead
  end

  def draw
    # Flip vertically when facing to the left.
    if @dir == :left
      offs_x = -1*OFFS_X*(SCALE)
      factor = SCALE
    else
      offs_x = OFFS_X*(SCALE)
      factor = -1*SCALE
    end
    @cur_image.draw(@x + offs_x, @y - (OFFS_Y*SCALE), 0, factor, SCALE)
  end

  # Could the object be placed at x + offs_x/y + offs_y without being stuck?
  def would_fit(offs_x, offs_y)
    # Check at the center/top and center/bottom for map collisions
    not @level.solid?(@x + offs_x, @y + offs_y) and
        not @level.solid?(@x + offs_x , @y + offs_y - OFFS_Y*SCALE*0.9)
  end

  def update(move_x)
    # Select image depending on action
    return if is_dead?
    if move_x == 0
      @cur_image = @standing
    else
      @cur_image = (Gosu.milliseconds / 175 % 2 == 0) ? @walk1 : @walk2
    end
    if @vy < 0
      @cur_image = @jump
    end

    # Directional walking, horizontal movement
    if move_x > 0
      @dir = :right
      move_x.times {
        if would_fit(1, 0)
        then
          @x += 1
        else
          if @x+20 > WIDTH && would_fit(-1*WIDTH + 20, 0)
            @x = 1
          end
        end }
    end
    if move_x < 0
      @dir = :left
      (-move_x).times {
        if would_fit(-1, 0)
        then
          @x -= 1
        else
          if @x-20 < 0 && would_fit(WIDTH - 20, 0)
            @x = WIDTH-20
          end
        end }
    end

    if @jump_slowness < 1
      @jump_slowness += 1
    else
      # Acceleration/gravity
      # By adding 1 each frame, and (ideally) adding vy to y, the player's
      # jumping curve will be the parabole we want it to be.
      @vy += 1 if @vy < 20
      if (@race == 1 and not Gosu.button_down? Gosu::KB_UP) or (@race == 2 and not Gosu.button_down? Gosu::KB_W)
        @vy += 1 if @vy < 20
      end

      @jump_slowness = 0
    end
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
      (-@vy).times {
        if would_fit(0, -1)
        then
          @y -= 1
        else
          @vy = 0
        end }
    end
  end

  def try_to_jump
    if @level.solid?(@x, @y +1)
      @vy = -15
      @jump_slowness = 0
      @jump_sample.play
    end
  end

  def shoot
    return if is_dead?
    if Gosu.milliseconds - @last_shot < SHOOT_DELAY - @firespeed
      return
    end
    @last_shot = Gosu.milliseconds
    if @dir == :left
      offs_x = -1*(OFFS_X*SCALE+5)
    else
      offs_x = OFFS_X*SCALE+5
    end

    @level.addBullet(@x+offs_x, @y - OFFS_Y*SCALE/2, @dir)
    @shot_sample.play
    if @boxes_collected > 9
      @level.addBullet(@x+offs_x, @y - OFFS_Y*SCALE/2, @dir, -1)
      @level.addBullet(@x+offs_x, @y - OFFS_Y*SCALE/2, @dir, 1)
    end

  end


end

require_relative 'static_object'

module RubyGame

  class MovingObject < StaticObject

    DEFAULT_SPEED = 1
    attr_accessor :speed

    def initialize(x, y, image_name)
      super
      @speed = DEFAULT_SPEED
      @speed_x = 0
      @speed_y = 0
    end

    def touch?(object)
      distance(object) < (object.width/2)
    end

    def distance(object)
      Math.hypot(@x - object.x, @y - object.y)
    end    

    def update
      @speed_x *= 0.9
      @speed_y *= 0.9

      return unless is_move_valid?
      @x += @speed_x
      @y += @speed_y
    end

    def move_up(speed = @speed)
      @speed_y -= speed
      self
    end

    def move_down(speed = @speed)
      @speed_y += speed
      self
    end

    def move_left(speed = @speed)
      @speed_x -= speed
      self
    end

    def move_right(speed = @speed)
      @speed_x += speed
      self
    end

    def move_random(speed = @speed)
      @available_moves ||= %w(move_up move_down move_left move_right)
      target_move = @available_moves.sample
      self.send target_move, speed
      self
    end

    def finish
      @draw_color = 0xffffffff
    end
    
    def speed(speed) #for DSL
      @speed = speed
    end

    private

    def is_move_valid?
      return false if (@x + @speed_x) <= @border_width + (@image.width/2)
      return false if (@x + @speed_x) >= @max_width - @border_width - (@image.width/2)
      return false if (@y + @speed_y) <= @border_width + @border_top_width + (@image.height/2)
      return false if (@y + @speed_y) >= @max_height - @border_width - (@image.height/2)
      true
    end

  end

end
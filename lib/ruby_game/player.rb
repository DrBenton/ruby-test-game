require_relative 'static_object'

module RubyGame
  
  class Player < StaticObject
    
    DEFAULT_PLAYER_SPEED = 1
    attr_accessor :speed
    
    def initialize(x, y, image_name = 'player')
      super
      self.draw_color = 0xffff0000
      self.speed = DEFAULT_PLAYER_SPEED
      @speed_x = 0
      @speed_y = 0
    end

    def init_limits(max_width, max_height, border_with, border_top_with)
      @max_width, @max_height = max_width, max_height
      @border_with, @border_top_with = border_with, border_top_with
    end
    
    def touch?(object)
      Math.hypot(@x - object.x, @y - object.y) < 50
    end
    
    def update
      @speed_x *= 0.9
      @speed_y *= 0.9
      
      return unless is_move_valid?
      @x += @speed_x
      @y += @speed_y
    end

    def move_up(speed = @speed)
      #@y -= speed if @y > @border_with + @border_top_with + (@image.height/2)
      @speed_y -= speed
      self
    end

    def move_down(speed = @speed)
      #@y += speed if @y < @max_height - @border_with - (@image.height/2)
      @speed_y += speed
      self
    end

    def move_left(speed = @speed)
      #@x -= speed if @x > @border_with + (@image.width/2)
      @speed_x -= speed
      self
    end

    def move_right(speed = @speed)
      #@x += speed if @x < @max_width - @border_with - (@image.width/2)
      @speed_x += speed
      self
    end
    
    def finish
      self.draw_color = 0xffffffff
    end
    
    private
    
      def is_move_valid?
        return false if (@x + @speed_x) <= @border_with + (@image.width/2) 
        return false if (@x + @speed_x) >= @max_width - @border_with - (@image.width/2)
        return false if (@y + @speed_y) <= @border_with + @border_top_with + (@image.height/2)
        return false if (@y + @speed_y) >= @max_height - @border_with - (@image.height/2)
        true
      end
    
  end
  
end
require_relative 'static_object'

module RubyGame
  
  class Player < StaticObject
    
    DEFAULT_PLAYER_SPEED = 5
    attr_accessor :speed
    
    def initialize(x, y, image_name = 'player')
      super
      self.draw_color = 0xffff0000
      self.speed = DEFAULT_PLAYER_SPEED
    end

    def init_limits(max_width, max_height, border_with, border_top_with)
      @max_width, @max_height = max_width, max_height
      @border_with, @border_top_with = border_with, border_top_with
    end

    def move_up(speed = @speed)
      @y -= speed if @y > @border_with + @border_top_with + (@image.height/2)
      self
    end

    def move_down(speed = @speed)
      @y += speed if @y < @max_height - @border_with - (@image.height/2)
      self
    end

    def move_left(speed = @speed)
      @x -= speed if @x > @border_with + (@image.width/2)
      self
    end

    def move_right(speed = @speed)
      @x += speed if @x < @max_width - @border_with - (@image.width/2)
      self
    end
    
  end
  
end
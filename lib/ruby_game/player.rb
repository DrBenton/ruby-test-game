require_relative 'moving_object'

module RubyGame
  
  class Player < MovingObject

    DANGER_DISTANCE = 100
    DANGER_DRAW_COLOR = 0xffff6600
    DANGER_DRAW_MODE = :add

    def initialize(x, y, image_name = 'player')
      super
    end
    
    def danger!
      @draw_color = DANGER_DRAW_COLOR
    end
    
    def safe!
      @draw_color = DEFAULT_DRAW_COLOR
    end

    
  end
  
end
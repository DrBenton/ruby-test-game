
module RubyGame
  
  class StaticObject
    
    DEFAULT_DEPTH = 1
    DEFAULT_ROTATION = 0
    DEFAULT_DRAW_COLOR = 0xffffffff

    attr_accessor :x, :y, :depth, :rotation, :draw_color
    
    def initialize(x,y, image_name)
      @x, @y = x, y
      @image_name = image_name
      
      self.depth = DEFAULT_DEPTH
      self.rotation = DEFAULT_ROTATION
      self.draw_color = DEFAULT_DRAW_COLOR
    end
    
    
    def init_image(window)
      @image = Gosu::Image.new(window, File.join(IMAGES_PATH, "#{@image_name}.png"))
    end
    
    def draw
      @image.draw_rot(@x, @y, self.depth, self.rotation, 0.5, 0.5, 1, 1, draw_color, :default)
    end
    
  end
  
end
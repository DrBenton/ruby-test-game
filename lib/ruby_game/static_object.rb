require 'forwardable'


module RubyGame
  
  class StaticObject
    
    extend Forwardable
    
    def_delegator :@image, :width
    
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

    def init_limits(max_width, max_height, border_width, border_top_width)
      @max_width, @max_height = max_width, max_height
      @border_width, @border_top_width = border_width, border_top_width
    end
    
    def random_pos_x!
      @x = rand( @border_top_width+100..(@max_width - 2*@border_top_width) )
    end

    def random_pos_y!
      @y = rand( @border_top_width+100..(@max_height - 2*@border_top_width) )
    end

    def random_pos!
      random_pos_x!
      random_pos_y!
    end
    
  end    
  
end
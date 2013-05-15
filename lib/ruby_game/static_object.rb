require 'forwardable'


module RubyGame
  
  class StaticObject
    
    extend Forwardable
    
    def_delegator :@image, :width
    
    DEFAULT_DEPTH = 1
    DEFAULT_ROTATION = 0
    DEFAULT_DRAW_COLOR = 0xffffffff
    DEFAULT_DRAW_MODE = :default

    attr_accessor :x, :y, :depth, :rotation, :draw_color, :draw_mode
    
    def initialize(x, y, image_name)
      @x, @y = x, y
      @image_name = image_name
      
      @depth = DEFAULT_DEPTH
      @rotation = DEFAULT_ROTATION
      @draw_color = DEFAULT_DRAW_COLOR
      @draw_mode = DEFAULT_DRAW_MODE
    end
    
    
    def init_image(window)
      @image = Gosu::Image.new(window, File.join(IMAGES_PATH, "#{@image_name}.png"))
    end
    
    def draw
      @image.draw_rot(@x, @y, @depth, @rotation, 0.5, 0.5, 1, 1, draw_color, @draw_mode)
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
    
    def image_name(img_name) #for DSL
      @image_name = img_name
    end

    def fade!
      @draw_mode = :add
      @draw_color = 0x80ffa0a0
    end

    def unfade!
      @draw_mode = DEFAULT_DRAW_MODE
    end
    
  end    
  
end
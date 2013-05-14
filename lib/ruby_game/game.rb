require 'gosu'

module RubyGame
  
  class Game < Gosu::Window
    
    DEBUG = 1
    BACKGROUND_DEPTH = 0
    
    def initialize(ruby, player, ghosts = {})
      super(640, 480, false)
      self.caption = "Ruby Game!"
      @ruby = ruby
      @player = player
    end

    def update
      
      return unless self.run?
      
      puts "update" if DEBUG > 1
      
      @player.move_left if button_down? Gosu::Button::KbLeft
      @player.move_right if button_down? Gosu::Button::KbRight
      @player.move_up if button_down? Gosu::Button::KbUp
      @player.move_down if button_down? Gosu::Button::KbDown
      
      @player.update

      if @player.touch? @ruby
        self.won!
        @player.finish
      end
    end

    def draw
      puts "draw" if DEBUG > 1

      @background_image.draw 0, 0, BACKGROUND_DEPTH

      @ruby.draw
      @player.draw
      
      @text.draw("You won!", 200, 240, 2, 1.0, 1.0, 0xffffff00) if won?

    end

    def start!
      @state = :run
      init_background
      init_core_sprites
      init_text
      self.show
    end
    
    def run?
      @state == :run
    end
    
    def won!
      @state = :won
    end
    
    def won?
      @state == :won
    end

    private

      def init_background
        @background_image = Gosu::Image.new(self, File.join(IMAGES_PATH, 'background.png'))
      end
  
      def init_core_sprites
        @ruby.init_image(self)
        @player.init_image(self)
        @player.init_limits width, height, 15, 40
      end
  
      def init_text
        @text = Gosu::Font.new(self, Gosu::default_font_name, 60)
      end
    
  end
  
end
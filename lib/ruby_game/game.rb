require 'gosu'

module RubyGame
  
  class Game < Gosu::Window
    
    DEBUG = 1
    BACKGROUND_DEPTH = 0
    MONSTERS_SPEED = 0.5
    
    def initialize
      super(640, 480, false)
      self.caption = "Ruby Game!"
      @initialized = false
      @monsters = []
    end

    def update
      
      return unless self.run?
      
      puts "update" if DEBUG > 1
      
      @player.move_left if button_down? Gosu::Button::KbLeft
      @player.move_right if button_down? Gosu::Button::KbRight
      @player.move_up if button_down? Gosu::Button::KbUp
      @player.move_down if button_down? Gosu::Button::KbDown
      
      @player.update
      
      @monsters.each do |monster|
        monster.update
        if monster.touch? @player
          self.lost!
        end
      end

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
      #puts "#{@monsters.length} monster(s) to handle..."
      @monsters.each(&:draw)

      #puts "won?=#{won?},lost?=#{lost?}"
      handle_text_scale if won? || lost?
      if won?
        @text.draw("You won!", @text_pos_x, @text_pos_y, 2, @text_scale, @text_scale, 0xffffff00)
      elsif lost?
        @text.draw("You loser!", @text_pos_x, @text_pos_y, 2, @text_scale, @text_scale, 0xffffff00)
      end
      
    end
    
    def button_down(id)
      self.close if id == Gosu::Button::KbEscape
      self.restart! if [:won, :lost].include?(@state) && id == Gosu::Button::KbSpace
    end
    
    def restart!
      @monsters.each do |monster|
        # force monsters random position for next round ! :-)
        monster.x = nil
        monster.y = nil
      end
      start!
    end

    def start!(&block)
      
      if block_given?
        @initializer = block # store init block for later use
      end
      
      # init !
      @initializer.call(self)
      
      @state = :run
      
      #puts "@initialized=#{@initialized}"
      init_core_sprites
      init_monsters
      init_text

      unless @initialized

        init_background

        @initialized = true
        
        self.show if block_given?

      end
      
    end
    
    def run?
      @state == :run
    end
    
    def won!
      @state = :won
      @text_scale_phase = :grow
    end
    
    def won?
      @state == :won
    end
    
    def lost!
      @state = :lost
      @text_scale_phase = :grow
    end
    
    def lost?
      @state == :lost
    end
    
    def ruby(ruby)
      @ruby = ruby
    end
    
    def player(player)
      @player = player
    end
    
    def monster(monster)
      @monsters << monster
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

      def init_monsters
        @monsters.each do |monster|
          monster.init_image(self)
          monster.init_limits width, height, 15, 40
          monster.set_target @player, MONSTERS_SPEED
        end
      end
  
      def init_text
        @text = Gosu::Font.new(self, Gosu::default_font_name, 60)

        @text_scale = 1.0
        @text_scale_grow_speed = 0.02
        @max_text_scale = 1.5
        @min_text_scale = 0.75
      end
    
    def handle_text_scale
      @text_scale += (@text_scale_phase == :grow) ? @text_scale_grow_speed : -@text_scale_grow_speed
      if @text_scale_phase == :grow && @text_scale > @max_text_scale
        @text_scale_phase = :shrink
      elsif @text_scale_phase == :shrink && @text_scale < @min_text_scale
        @text_scale_phase = :grow
      end
      @text_pos_x = width/2 - (100 * @text_scale)
      @text_pos_y = height/2 - (10 * @text_scale)
    end
    
    
  end
  
end
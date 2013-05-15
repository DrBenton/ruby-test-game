require 'gosu'

module RubyGame
  
  class Game < Gosu::Window
    
    DEBUG = 1
    BACKGROUND_DEPTH = 0
    ROUND_START_INVICIBILITY_DURATION = 30
    BACKGROUND_SCALE = 1.5
    
    def initialize
      @width = (640 * BACKGROUND_SCALE).to_i
      @height = (480 * BACKGROUND_SCALE).to_i
      super(@width , @height, false, 1000/30) # 30fps, please
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
      @player.safe!
      
      if @countdown_before_ennemies_activation == 0
        
        @monsters.each do |monster|
          monster.update @player
          if monster.distance(@player) < Player::DANGER_DISTANCE
            @player.danger!
          end
          if monster.touch? @player
            self.lost!
          end
        end

        if @ruby.visible? && @player.touch?(@ruby)
          self.won!
          @player.finish
        end
        
      end

      @countdown_before_ennemies_activation -= 1 if @countdown_before_ennemies_activation > 0
      
      if @countdown_before_ennemies_activation == 1
        @monsters.each do |monster|
          monster.unfade!
        end
        @ruby.show!
      end
      
    end

    def draw
      puts "draw" if DEBUG > 1

      @background_image.draw 0, 0, BACKGROUND_DEPTH, BACKGROUND_SCALE, BACKGROUND_SCALE

      @ruby.draw
      @player.draw
      #puts "#{@monsters.length} monster(s) to handle..."
      @monsters.each(&:draw)

      #puts "won?=#{won?},gameover?=#{gameover?}"
      handle_text_scale if won? || gameover?
      if won?
        @text.draw("You won!", @text_pos_x, @text_pos_y, 2, @text_scale, @text_scale, 0xffffff00)
      elsif gameover?
        @text.draw("You loser!", @text_pos_x, @text_pos_y, 2, @text_scale, @text_scale, 0xffffff00)
      end
      
    end
    
    def button_down(id)
      self.close if id == Gosu::Button::KbEscape
      self.restart! if [:won, :lost].include?(@state) && id == Gosu::Button::KbSpace
    end

    def start!(&block)
      
      if block_given?
        @initializer = block # store init block for later use
      end
      
      # init !
      @monsters.clear
      self.instance_eval &@initializer

      @state = :run

      #puts "@initialized=#{@initialized}"
      init_core_sprites
      init_monsters
      init_text
      
      @ruby.random_pos!
      @ruby.hide!
      
      @countdown_before_ennemies_activation = ROUND_START_INVICIBILITY_DURATION

      unless @initialized

        init_background

        @initialized = true
        
        self.show if block_given? # "show" is a blocking call : any following code in the method won't be reached!

      end
      
    end
    
    alias_method :restart!, :start!
    
    def won!
      @state = :won
      @text_scale_phase = :grow
    end
    
    def lost!
      @state = :lost
      @text_scale_phase = :grow
    end
   
    # let's define "state getter" at runtime... Ruby metaprogrammation powhaaaaa!
    %w(won run gameover).each do |state|
      state_sym = state.to_sym
      define_method "#{state}?" do 
        @state == state_sym
      end
    end
    
    # let's define "entity setter" at runtime... Ruby metaprogrammation powhaaaaa! (bis)
    %w(ruby player).each do |entity|
      define_method "#{entity}" do |entity_instance|
        instance_variable_set "@#{entity}", entity_instance
      end
    end
    
    def monster(monster)
      @monsters << monster
    end
    
    def monsters(monsters_array)
      @monsters += monsters_array
    end

    private

      def init_background
        @background_image = Gosu::Image.new(self, File.join(IMAGES_PATH, 'background.png'))
      end
  
      def init_core_sprites
        @ruby.init_image(self)
        @ruby.init_limits width, height, 15, 40
        @player.init_image(self)
        @player.init_limits width, height, 15, 40
      end

      def init_monsters
        @monsters.each do |monster|
          monster.init_image(self)
          monster.init_limits width, height, 15, 40
          monster.random_pos!
          monster.fade!
          monster.set_target @player
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
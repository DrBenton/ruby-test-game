require_relative 'moving_object'

module RubyGame
  
  class Monster < MovingObject
    
    @@profiles = {}
    
    def initialize(x = nil, y = nil, image_name = 'ghost1')
      super
    end

    def self.define_profile(profile_name_sym, &init_block)
      monster_profile_model = Monster.new
      monster_profile_model.instance_eval(&init_block)
      @@profiles[profile_name_sym] = monster_profile_model
    end

    def self.build(profile_name_sym)
      monster_profile_model = @@profiles[profile_name_sym]
      monster_profile_model.clone
    end

    def init_limits(max_width, max_height, border_width, border_top_width)
      super
    end

    def random_pos!
      random_pos_x! if @x.nil?
      random_pos_y! if @y.nil?
    end
    
    def set_target(target, speed = @speed)
      @target = target
      @to_target_speed = speed
    end
    
    def update
      
      unless @target.nil?
        
        if x < @target.x
          self.move_right @to_target_speed
        elsif x > @target.x
          self.move_left @to_target_speed
        end

        if y < @target.y
          self.move_down @to_target_speed
        elsif y > @target.y
          self.move_up @to_target_speed
        end

      end #end unless @target.nil?
      
      super
      
    end

    
  end
  
end
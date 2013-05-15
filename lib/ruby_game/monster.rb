require_relative 'moving_object'

module RubyGame
  
  class Monster < MovingObject
    
    ACTION = Struct.new(:type, :speed)
    
    attr_reader :pending_actions
    
    @@profiles = {}
    
    def initialize(x = nil, y = nil, image_name = 'ghost1')
      super
      @pending_actions = []
    end

    def hello_world
      puts "New monster on the bridge, captain! My object id is #{object_id}, I have #{@pending_actions.length} pending actions to handle"
    end

    def self.define_profile(profile_name_sym, &init_block)
      @@profiles[profile_name_sym] = init_block
    end

    def self.build(profile_name_sym)
      monster_profile_init_block = @@profiles[profile_name_sym]
      puts "monster_profile_model.pending_actions = "
      new_monster = self.new
      new_monster.instance_eval(&monster_profile_init_block)
      new_monster.hello_world
      new_monster
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
    
    def action(type, opts = nil)
      puts "#{self.class}.action(#{type}, #{opts.inspect})"
      # opts setup
      opts ||= {}
      speed = opts[:speed] || DEFAULT_SPEED
      nb_actions = opts[:repeat] || 1
      # go!
      @pending_actions ||= []
      nb_actions.times do
        @pending_actions << ACTION.new( type, speed ) 
      end
    end
    
    def update
      
      #puts @pending_actions.length
      
      unless @pending_actions.empty?
        next_action = @pending_actions.shift
        #puts "next_action=#{next_action.inspect}"
        send("#{next_action.type}", next_action.speed)
        super
        return
      end
      
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
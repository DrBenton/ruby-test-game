require_relative 'moving_object'

module RubyGame
  
  class Monster < MovingObject
    
    ACTION = Struct.new(:type, :speed)
    
    DANGER_DRAW_COLOR = 0xffff0000
    DANGER_DISTANCE = 50
    
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

    def self.build(profile_name_sym, num_instances = 1)
      
      monster_profile_init_block = @@profiles[profile_name_sym]
      new_monsters = []
      
      num_instances.times do
        new_monster = self.new
        new_monster.instance_eval(&monster_profile_init_block)
        #new_monster.hello_world
        new_monsters << new_monster
      end

      new_monsters
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
      #puts "#{self.class}.action(#{type}, #{opts.inspect})"
      # opts setup
      opts ||= {}
      opts = {speed: @speed, repeat: 1}.merge opts
      # go!
      @pending_actions ||= []
      opts[:repeat].times do
        @pending_actions << ACTION.new( type, opts[:speed] ) 
      end
    end
    
    def update(player)
      
      #puts @pending_actions.length
      
      @pending_actions_enum ||= @pending_actions.cycle # create an iterator
      next_action = @pending_actions_enum.next

      if next_action.type == :hunt
        hunt_target player
      else
        send("#{next_action.type}", next_action.speed)
      end
      
      @draw_color = distance(player) < DANGER_DISTANCE ? DANGER_DRAW_COLOR : DEFAULT_DRAW_COLOR
      
      super()

    end
    
    def hunt_target(target)
      if x < target.x
        move_right @to_target_speed
      elsif x > target.x
        move_left @to_target_speed
      end

      if y < target.y
        move_down @to_target_speed
      elsif y > target.y
        move_up @to_target_speed
      end
    end

    
  end
  
end
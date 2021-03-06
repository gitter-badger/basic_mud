module ClasslessMud
  class Exit
    OPPOSITES = {
      'north' => 'south',
      'south' => 'north',
      'west' => 'east',
      'east' => 'west',
      'up' => 'down',
      'down' => 'up'
    }
    DIRECTIONS = ['north', 'south', 'east', 'west', 'up', 'down']
    include DataMapper::Resource

    property :id, Serial
    property :direction, String
    belongs_to :source, 'Room', :key => true
    belongs_to :target, 'Room', :key => true
    validates_with_method :direction, :method => :case_insensitive_direction_check

    def self.opposite(direction)
      OPPOSITES[direction]
    end

    def case_insensitive_direction_check
      DIRECTIONS.include? self.direction.downcase
    end
  end
end

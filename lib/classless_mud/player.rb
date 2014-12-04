module ClasslessMud
  class Player
    include DataMapper::Resource
    property :id, Serial
    property :name, String
    belongs_to :room

    attr_reader :name

    def self.accept client, name
      player = first(:name => name.chomp) || Player.create(:name => name.chomp)
      player.client= client
      player
    end

    def client= client
      @client = client
    end

    def puts message
      @client.puts message
    end

    def close_client
      @client.close_connection
    end

    def handle_message message
      if message == 'quit'
        puts "Are you sure you want to quit? y/n: "
        @client.on do |response|
          if response == 'y' || response == 'Y'
            puts "Thanks for playing"
            room.exit self
            close_client
          end
        end
      elsif message == 'dance'
        puts "Are you sure you want to dance? y/n: "
        @client.on do |response|
          if response == 'y' || response == 'Y'
            puts 'You are a dancing fool'
          end
        end
      else
        move message
      end
    end

    def move direction
      valid_exit = self.room.exits.detect {|exit| exit.direction == direction}
      if valid_exit
        room.exit self
        valid_exit.target.enter self
      else
        puts "You can't go that way."
      end
    end
  end
end

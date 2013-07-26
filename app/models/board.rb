require 'yaml'

class Board < ActiveRecord::Base
  @@WIDTH = 10
  @@HEIGHT = 10
  
  @@PLAYERS = ["X", "O"]

  class Strategy
    def initialize(change_x, change_y)
      @change_x = change_x
      @change_y = change_y
    end
    def back(x, y, n)
      [x-@change_x*n, y-@change_y*n]
    end
    def forward(x, y, n)
      [x+@change_x*n, y+@change_y*n]
    end
  end
  @@STRATEGIES = [Strategy.new(1, 0), Strategy.new(0, 1), Strategy.new(1, 1), Strategy.new(1, -1)]
  
  before_save do
    self.data = self.data
  end
  
  def width
    @@WIDTH
  end
  def height
    @@HEIGHT
  end
  def turn
    @@PLAYERS[turns % @@PLAYERS.size]
  end
  def next_turn
    @@PLAYERS[(turns+1) % @@PLAYERS.size]
  end

  def initialize
    super
    write_attribute(:data, {}.to_yaml)
  end
  
  def place_piece(player, x)
    y = pos_y(x) + 1
    raise "Invalid position #{x}" unless valid_position?(x,y)
    data[x] ||= {}
    data[x][y] = player
    self.turns += 1
  end
  def find_winner(last_x)
    return self.winner if self.winner
    last_y = pos_y(last_x)
    player = data[last_x][last_y]
    raise "no piece at #{last_x},#{last_y}" if player.nil?
    self.winner = player if @@STRATEGIES.any? { |s| check_for_strategy(last_x, last_y, data[last_x][last_y], s) >= 4 }
    return winner
  end
  def strategies
    @@STRATEGIES
  end
  def data
    @data ||= YAML.load read_attribute(:data)
  end
  def pos_y(x)
    data[x] ? data[x].keys.max : -1
  end
  def valid_position?(x,y)
    0 <= x && x < @@WIDTH && 0 <= y && y < @@HEIGHT
  end

  def data=(hash)
    write_attribute(:data, hash.to_yaml)
  end
  def check_for_strategy(x, y, player, strategy)
    left = 0
    begin
      left += 1
      next_pos = strategy.back(x, y, left)
    end while (valid_position?(next_pos[0],next_pos[1]) && data[next_pos[0]].try(:[], next_pos[1]) == player)
    possible_left = left
    begin
      possible_left += 1
      next_pos = strategy.back(x, y, possible_left)
    end while (valid_position?(next_pos[0],next_pos[1]) && data[next_pos[0]].try(:[], next_pos[1]) != next_turn)
    
    right = 0
    begin
      right += 1
      next_pos = strategy.forward(x, y, right)
    end while (valid_position?(next_pos[0],next_pos[1]) && data[next_pos[0]].try(:[], next_pos[1]) == player)
    possible_right = right
    begin
      possible_right += 1
      next_pos = strategy.back(x, y, possible_right)
    end while (valid_position?(next_pos[0],next_pos[1]) && data[next_pos[0]].try(:[], next_pos[1]) != next_turn)
    
    possible = possible_right + possible_left - 1 >= 4
    result = right + left - 1
    result = 0 unless possible

    puts "pos #{x}, #{y}"
    puts "possible #{possible_left} #{possible_right} #{possible}"
    puts "result #{result}"
    result
  end
end

class Ai
  def self.place_piece(board)
    results = {}
    0.upto(board.width - 1).each do |x|
      score = 0
      y = board.pos_y(x) + 1
      if board.valid_position?(x,y)
        score += make_or_block_row(board, x, y)
        score += middle(board, x, y)
        score += higher(board, x, y)
        puts "#{x} #{score}"
        results[score] = x
      end
    end
    results[results.keys.max]
  end
  def self.make_or_block_row(board, x, y)
    make = (make_row(board, x, y)-1)*1000
    block = (block_row(board, x, y)-1)*1000 - 50
    result = [block, make].max #+ [block, make].min / 2
    result -= 3900 if board.strategies.collect { |s| board.check_for_strategy(x, y+1, board.next_turn, s) }.max >= 4
    result
  end
  def self.make_row(board, x, y)
    make = board.strategies.collect { |s| board.check_for_strategy(x, y, board.turn, s) }.max
    make = 4 if make > 4
    #make = (make-1)*100
    #[block, make].max + [block, make].min / 2
    make
  end
  def self.block_row(board, x, y)
    block = board.strategies.collect { |s| board.check_for_strategy(x, y, board.next_turn, s) }.max
    block = 4 if block > 4
    #block = (block-1)*100 - 50
    #block = 0 if block < 0

    block
  end
  def self.middle(board, x, y)
    board.width - (x - board.width/2).abs
  end
  def self.higher(board, x, y)
    y
  end
end
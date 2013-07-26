class BoardsController < ApplicationController
  def new
    @board = Board.new
    @board.save!
    render "show"
  end
  def update
    @board = Board.find(params[:id])
    @board.place_piece(params[:player], params[:place_x].to_i)
    @winner = @board.find_winner(params[:place_x].to_i)
    unless @winner
      pos = Ai.place_piece(@board)
      @board.place_piece(@board.turn, pos)
      @winner = @board.find_winner(pos)
    end
    @board.save!
    render "show"
  end
  def show
    @board = Board.find(params[:id])
    @winner = @board.winner
  end
end

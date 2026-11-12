# frozen_string_literal: true

# Turn management, check/checkmate detection, and overall game flow.
require_relative 'board'
require_relative 'player'

class Game # rubocop:disable Style/Documentation
  attr_reader :board

  def initialize(board: Board.new, current_player: :white)
    @board = board
    @current_player = current_player
  end
  # ... play, prompt_move, switch_turn methods ...
  play_turn

  private

  def play_turn
    puts "\n--- It's #{@current_player.capitalize}'s Turn ---"
    puts "#{@current_player.capitalize} is in check!" if board.in_check?(@current_player)
    loop until game_over? do
      move = prompt_move
      next unless board.valid_move?(move) # If format was invalid, prompt again

      board.move_piece(piece.positon, move)
    end
    switch_turn
  end

  def prompt_move
    print 'Enter your move: '
    gets.chomp
  end

  def switch_turn
    @current_player == if @current_player == :white
                         :black
                       else
                         :white
                       end
  end

  def game_over? # rubocop:disable Metrics/MethodLength
    if board.checkmate?
      puts 'Game Over by Checkmate'
      true
    elsif board.stalement?
      puts 'Game Over by Stalemate'
      true
    elsif board.insufficient_material?
      puts 'Game Over By Insufficient Material - Draw'
      true
    else
      false
    end
  end
end

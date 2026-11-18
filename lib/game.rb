# frozen_string_literal: true

require_relative 'board'
require_relative 'player'
require_relative 'display'
# Turn management, check/checkmate detection, and overall game flow.
class Game
  attr_reader :current_player, :board, :white_player, :black_player

  def initialize(white_player = Player.new(:white), black_player = Player.new(:black))
    raise ArgumentError, 'White player must be white' unless white_player.color == :white
    raise ArgumentError, 'Black player must be black' unless black_player.color == :black

    @board = Board.new
    @white_player = white_player
    @black_player = black_player
    @current_player = @white_player
  end

  # Turn managament
  def switch_turn
    @current_player = if @current_player == @white_player
                        @black_player
                      else
                        @white_player
                      end
  end

  # Overall game flow
  def play # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
    display = Display.new

    loop do # rubocop:disable Metrics/BlockLength
      # 1. Check for game over before starting/continuing
      if game_over?
        announce_game_over
        break
      end

      # 2. Display the board at the start of every turn
      puts display.render(board)
      puts "\n"
      # 3. Run the turn sequence
      puts "#{current_player.name} (#{current_player.color.capitalize})'s turn."
      begin
        input = gets
        if input.nil?
          puts 'Game terminated. Thanks for playing!'
          return
        else
          input = input.chomp
        end
        from, to = parse_move(input)
        board.move_piece(from, to)
        piece = board.last_move[:piece]
        if board.promotion_allowed?(piece)
          promotion_choice = prompt_promotion_piece
          board.execute_promotion(piece, promotion_choice)
        end

        # Only switch turns if the move was completely successful
        switch_turn
      rescue ArgumentError => e
        # Catch errors from parse_move or board.move_piece
        puts "\nInvalid move: #{e.message}. Please try again.\n"
      end
    end
  end

  private

  def game_over?
    return true if board.checkmate?(current_player.color)
    return true if board.insufficient_material?
    return true if board.stalemate?(current_player.color)

    false
  end

  def announce_game_over
    if board.stalemate?(current_player.color)
      puts 'Game over by stalemate.'
    elsif board.insufficient_material?
      puts 'Game over by insufficient material.'
    elsif board.checkmate?(current_player.color)
      puts "Game over by checkmate. #{current_player.color.capitalize} loses."
    end
  end

  def parse_move(input)
    cleaned = input.strip.downcase.split(/\s+/)

    # Check that we received exactly 2 parts (the "from" and "to" squares)
    raise ArgumentError, "Invalid format. Please use 'e2 e4'." unless cleaned.length == 2

    from_str = cleaned[0] # "e2"
    to_str = cleaned[1]   # "e4"

    # Now you can translate from_str and to_str...

    [translate_coordinate(from_str), translate_coordinate(to_str)]
  end

  def translate_coordinate(coord_str)
    raise ArgumentError, "Invalid coordinate: #{coord_str}" unless coord_str =~ /^[a-h][1-8]$/

    file = coord_str[0] # 'a' through 'h'
    rank = coord_str[1] # '1' through '8'

    col = file.ord - 'a'.ord

    row = 8 - rank.to_i

    [row, col]
  end

  def prompt_promotion_piece # rubocop:disable Metrics/MethodLength
    loop do
      puts 'Pawn promotion! Choose piece ([q]ueen, [r]ook, [b]ishop, [k]night):'
      choice = gets

      if choice.nil?
        puts 'Game terminated. Thanks for playing!'
        return
      else
        choice = choice.chomp.strip.downcase
      end

      case choice
      when 'q', 'queen'   then return :queen
      when 'r', 'rook'    then return :rook
      when 'b', 'bishop'  then return :bishop
      when 'k', 'knight'  then return :knight
      else
        puts 'Invalid choice. Please try again.'
      end
    end
  end
end

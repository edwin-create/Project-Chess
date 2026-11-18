# frozen_string_literal: true

require_relative 'board'

# Class responsible for displaying messages to the user
class Display
  PIECE_SYMBOLS = {
    king: "\u265A",
    queen: "\u265B",
    rook: "\u265C",
    bishop: "\u265D",
    knight: "\u265E",
    pawn: "\u265F\uFE0E"
  }.freeze

  # High-contrast foreground colors
  PIECE_COLORS = {
    white: "\e[38;2;255;255;255m", # Crisp white
    black: "\e[38;2;20;20;20m" # Deep charcoal
  }.freeze

  SQUARE_COLORS = {
    light: "\e[48;2;222;184;135m",
    dark: "\e[48;2;140;100;65m"
  }.freeze

  def initialize(board = Board.new)
    @board = board
  end

  def introduction
    puts 'Welcome to Chess!'
    puts 'Players take turns moving pieces around the board.'
    puts 'The first player to checkmate their opponent wins!'
  end

  def render
    output = String.new
    output << column_labels
    output << "\n"
    output << horizontal_border
    output << "\n"
    render_rows(output)
    output << column_labels
    output << "\n"
    output
  end

  private

  def render_rows(output) # rubocop:disable Metrics/MethodLength
    # We display ranks from 8 down to 1 for the board, but the board itself is stored
    # with zero-based indexes in arrays, so row 8 becomes index 7 and row 1 becomes index 0.
    # That is why we pass 8-row into render_square: the printed rank is 1-based, but
    # the internal board coordinates are 0-based.
    8.downto(1) do |row|
      output << "#{row} |"

      # The column loop starts at 0 because Ruby arrays and board positions are zero-indexed.
      # This matches the coordinate system used by square_color and render_square.
      1.upto(8) do |col|
        output << render_square(8 - row, col - 1)
        output << '|'
      end

      output << " #{row}"
      output << "\n"
      output << horizontal_border
      output << "\n"
    end
  end

  def square_color(row, col)
    if (row + col).even?
      :light
    else
      :dark
    end
  end

  def render_square(row, col)
    background_color = SQUARE_COLORS[square_color(row, col)]

    piece = @board.piece_at([row, col])

    contents = piece ? " #{PIECE_SYMBOLS[piece.piece_type]} " : '   '

    foreground = piece ? PIECE_COLORS[piece.color] : ''

    "#{background_color}#{foreground}#{contents}\e[0m"
  end

  def horizontal_border
    '  +---+---+---+---+---+---+---+---+'
  end

  def column_labels
    '    a   b   c   d   e   f   g   h'
  end
end

# frozen_string_literal: true

require_relative 'pawn'
require_relative 'rook'
require_relative 'knight'
require_relative 'bishop'
require_relative 'queen'
require_relative 'king'
# Handles the grid, piece placement, and move application.
class Board
  attr_reader :grid

  def initialize # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    @grid = Array.new(8) { Array.new(8) }
    grid[0][0] = Rook.new(:black, [0, 0])
    grid[0][1] = Knight.new(:black, [0, 1])
    grid[0][2] = Bishop.new(:black, [0, 2])
    grid[0][3] = Queen.new(:black, [0, 3])
    grid[0][4] = King.new(:black, [0, 4])
    grid[0][5] = Bishop.new(:black, [0, 5])
    grid[0][6] = Knight.new(:black, [0, 6])
    grid[0][7] = Rook.new(:black, [0, 7])
    (0..7).each do |col|
      grid[1][col] = Pawn.new(:black, [1, col])
      grid[6][col] = Pawn.new(:white, [6, col])
    end
    grid[7][0] = Rook.new(:white, [7, 0])
    grid[7][1] = Knight.new(:white, [7, 1])
    grid[7][2] = Bishop.new(:white, [7, 2])
    grid[7][3] = Queen.new(:white, [7, 3])
    grid[7][4] = King.new(:white, [7, 4])
    grid[7][5] = Bishop.new(:white, [7, 5])
    grid[7][6] = Knight.new(:white, [7, 6])
    grid[7][7] = Rook.new(:white, [7, 7])
  end

  def piece_at(position)
    raise ArgumentError, 'Invalid position' unless valid_position?(position)

    row, col = position
    grid[row][col]
  end

  def move_piece(from, to) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    raise ArgumentError, 'Invalid position' unless valid_position?(from) && valid_position?(to)

    piece = piece_at(from)
    raise ArgumentError, 'No piece at starting position' if piece.nil?

    destination_piece = piece_at(to)
    if destination_piece && destination_piece.color == piece.color
      raise ArgumentError, 'Cannot move to a position occupied by a friendly piece'
    end

    raise ArgumentError, 'Invalid move for the piece' unless valid_move?(piece, to)

    grid[to[0]][to[1]] = piece
    grid[from[0]][from[1]] = nil
    piece.update_position(to)
  end

  def valid_move?(piece, to)
    if piece.is_a?(Pawn)
      valid_pawn_move?(piece, to)
    else
      regular_move?(piece, to)
    end
  end

  private

  def valid_pawn_move?(piece, to)
    return false unless piece.is_a?(Pawn) && valid_position?(to)

    target = piece_at(to)

    if target.nil?
      pawn_can_advance?(piece, to)
    else
      pawn_can_capture?(piece, to, target)
    end
  end

  def pawn_can_advance?(pawn, to)
    pawn.valid_moves.include?(to) && path_clear?(pawn.position, to)
  end

  def pawn_can_capture?(pawn, to, target)
    pawn.capture_moves.include?(to) && pawn.color != target.color
  end

  def regular_move?(piece, to) # rubocop:disable Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity,Metrics/MethodLength
    return false unless valid_position?(to)
    return false if piece.nil?

    destination_piece = piece_at(to)

    return false unless piece.valid_moves.include?(to)
    return false if destination_piece && destination_piece.color == piece.color

    if (piece.is_a?(Bishop) || piece.is_a?(Rook) || piece.is_a?(Queen)) && !path_clear?(
      piece.position, to
    )
      return false
    end

    true
  end

  def path_clear?(from, to) # rubocop:disable Metrics/MethodLength
    row1, col1 = from
    row2, col2 = to

    row_step = row2 <=> row1
    col_step = col2 <=> col1

    current_row = row1 + row_step
    current_col = col1 + col_step

    while current_row != row2 || current_col != col2
      return false unless piece_at([current_row, current_col]).nil?

      current_row += row_step
      current_col += col_step
    end

    true
  end

  def valid_position?(position)
    return false unless position.is_a?(Array)
    return false if position.length != 2

    position.all? { |coord| coord.is_a?(Integer) && coord.between?(0, 7) }
  end
end

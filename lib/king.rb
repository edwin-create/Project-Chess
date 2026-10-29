# frozen_string_literal: true

require_relative 'piece'
# One-square movement
class King < Piece
  KING_MOVES = [
    [1, 0],
    [-1, 0],
    [0, 1],
    [0, -1],
    [1, 1],
    [1, -1],
    [-1, 1],
    [-1, -1]
  ].freeze

  def valid_moves
    row, col = position
    potential_moves = KING_MOVES.map { |move| [row + move[0], col + move[1]] }
    potential_moves.select { |move| valid_position?(move) }
  end

  def piece_type
    :king
  end
end

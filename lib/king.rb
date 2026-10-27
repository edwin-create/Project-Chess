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
    x, y = position
    potential_moves = KING_MOVES.map { |move| [x + move[0], y + move[1]] }
    potential_moves.select { |move| valid_position?(move) }
  end
end

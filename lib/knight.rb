# frozen_string_literal: true

# L-shaped movement.

require_relative 'piece'

class Knight < Piece # rubocop:disable Style/Documentation
  KNIGHT_MOVES = [
    [2, 1],
    [2, -1],
    [-2, 1],
    [-2, -1],
    [1, 2],
    [1, -2],
    [-1, 2],
    [-1, -2]
  ].freeze

  def valid_moves
    row, col = position
    potential_moves = KNIGHT_MOVES.map { |move| [row + move[0], col + move[1]] }
    potential_moves.select { |move| valid_position?(move) }
  end

  def piece_type
    :knight
  end
end

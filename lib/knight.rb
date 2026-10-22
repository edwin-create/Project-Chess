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
    x, y = position
    potential_moves = KNIGHT_MOVES.map { |move| [x + move[0], y + move[1]] }
    potential_moves.select { |move| valid_position?(move) }
  end
end
